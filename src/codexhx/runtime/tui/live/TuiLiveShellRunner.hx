package codexhx.runtime.tui.live;

import codexhx.protocol.RequestId;
import codexhx.runtime.tui.appserver.TuiAppServerEventPump;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellRenderer;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalInputMapper;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSchedulerEvent;
import codexhx.runtime.tui.terminal.TerminalSchedulerEffect;
import codexhx.runtime.tui.terminal.TerminalSchedulerRunner;

/**
	Runs the first credential-free live TUI shell loop.

	This is intentionally small: it owns terminal setup/restore and event
	dispatch, while the fake app-server facade and ChatWidget shell own state
	mutation. The loop is bounded so the same code path is usable in headless CI
	and generated Rust smoke gates.
**/
class TuiLiveShellRunner {
	public static function run(request:TuiLiveShellRunRequest):TuiLiveShellRunOutcome {
		final outcome = new TuiLiveShellRunOutcome();
		final setup = request.backend.setup(request.setup);
		outcome.recordSetup(setup);
		if (!setup.ok) {
			recordTurnState(request, outcome);
			shutdownPromptTransport(request, outcome, "live_shell_setup_failed");
			outcome.recordRestore(request.backend.restore(TerminalRestoreReason.ErrorExit));
			return outcome;
		}

		final pump = new TuiAppServerEventPump(request.facade, request.scheduler, request.backend);
		try {
			attachSession(request);
			enqueueInitialEvents(request);
			flushCurrentFrame(request, outcome);
			runLoop(request, pump, outcome);
			recordTurnState(request, outcome);
			shutdownPromptTransport(request, outcome, "live_shell_runner_done");
			outcome.recordRestore(request.backend.restore(TerminalRestoreReason.NormalExit));
		} catch (message:String) {
			outcome.recordExit(TerminalExitReason.Error);
			request.backend.requestExit(TerminalExitReason.Error);
			recordTurnState(request, outcome);
			shutdownPromptTransport(request, outcome, "live_shell_runner_error");
			outcome.recordRestore(request.backend.restore(TerminalRestoreReason.ErrorExit));
			throw message;
		}
		return outcome;
	}

	static function shutdownPromptTransport(request:TuiLiveShellRunRequest, outcome:TuiLiveShellRunOutcome, code:String):Void {
		outcome.recordPromptTransportShutdown(request.facade.shutdownPromptTransport(code));
	}

	static function recordTurnState(request:TuiLiveShellRunRequest, outcome:TuiLiveShellRunOutcome):Void {
		outcome.recordTurnState(request.facade.activeTurnIdText(), request.facade.lastStartedTurnIdText(), request.facade.lastCompletedTurnIdText(),
			request.facade.lastInterruptedTurnIdText(), request.facade.completedTurnCount(), request.facade.interruptedTurnCount(),
			request.facade.lastInterruptCode());
	}

	static function attachSession(request:TuiLiveShellRunRequest):Void {
		final attachRequest = RequestId.fromInteger(1);
		request.facade.startSessionAttach(attachRequest, request.sessionId, request.primaryThreadId, request.modelLabel);
		request.facade.completeSessionAttach(attachRequest);
		request.scheduler.handle(TerminalSchedulerEvent.DrawRequested);
	}

	static function enqueueInitialEvents(request:TuiLiveShellRunRequest):Void {
		for (event in request.initialEvents)
			request.facade.enqueue(event);
	}

	static function runLoop(request:TuiLiveShellRunRequest, pump:TuiAppServerEventPump, outcome:TuiLiveShellRunOutcome):Void {
		var idleEvents = 0;
		var nextRequestId = 2;
		while (!request.scheduler.exitRequested()
			&& outcome.iterations() < request.policy.maxIterations
			&& idleEvents < request.policy.idleEventLimit) {
			outcome.recordIteration();
			recordPump(request, outcome, pump.drain(request.policy.appServerPolicy));
			if (request.scheduler.exitRequested())
				break;

			final event = request.backend.pollEvent();
			outcome.recordTerminalEvent();
			switch event {
				case TerminalEvent.NoEvent:
					idleEvents = idleEvents + 1;
					outcome.recordNoEvent();
				case TerminalEvent.Tick:
					idleEvents = 0;
					request.scheduler.handle(TerminalSchedulerEvent.Tick);
					flushCurrentFrame(request, outcome);
				case TerminalEvent.DrawRequested:
					idleEvents = 0;
					request.scheduler.handle(TerminalSchedulerEvent.DrawRequested);
					flushCurrentFrame(request, outcome);
				case TerminalEvent.Resize(size):
					idleEvents = 0;
					outcome.recordResizeEvent();
					request.scheduler.handle(TerminalSchedulerEvent.Resize(size));
					flushCurrentFrame(request, outcome);
				case TerminalEvent.Exit(reason):
					idleEvents = 0;
					handleExit(request, outcome, reason);
				case TerminalEvent.Key(key):
					idleEvents = 0;
					outcome.recordKeyEvent();
					if (shouldInterruptOnKey(request, key)) {
						request.facade.interruptActiveTurn(RequestId.fromInteger(nextRequestId));
						nextRequestId = nextRequestId + 1;
						recordPump(request, outcome, pump.drain(request.policy.appServerPolicy));
						recordCurrentFrame(request, outcome);
					} else if (shouldQuitOnKey(request, key)) {
						handleExit(request, outcome, TerminalExitReason.Requested);
					} else {
						final interaction = pump.submitComposerInput(TerminalInputMapper.inputFromTerminalKey(key), RequestId.fromInteger(nextRequestId),
							request.policy.appServerPolicy);
						nextRequestId = nextRequestId + 1;
						outcome.recordPromptInteraction(interaction);
						recordCurrentFrame(request, outcome);
						if (request.scheduler.exitRequested())
							outcome.recordExit(request.scheduler.exitReason());
					}
			}
		}
	}

	static function recordPump(request:TuiLiveShellRunRequest, outcome:TuiLiveShellRunOutcome,
			pumpOutcome:codexhx.runtime.tui.appserver.TuiAppServerPumpOutcome):Void {
		outcome.recordPumpOutcome(pumpOutcome);
		if (pumpOutcome != null && pumpOutcome.schedulerDrawFrameCount() > 0)
			recordCurrentFrame(request, outcome);
	}

	static function handleExit(request:TuiLiveShellRunRequest, outcome:TuiLiveShellRunOutcome, reason:TerminalExitReason):Void {
		outcome.recordExit(reason);
		final effects = request.scheduler.handle(TerminalSchedulerEvent.AppExit(reason));
		outcome.recordTerminalOperations(TerminalSchedulerRunner.applyEffects(request.backend, effects));
	}

	static function flushCurrentFrame(request:TuiLiveShellRunRequest, outcome:TuiLiveShellRunOutcome):Void {
		final frame = ChatWidgetShellRenderer.render(request.shell, request.scheduler.currentSize());
		final effects = request.scheduler.flush(frame);
		if (drawFrameCount(effects) > 0)
			outcome.recordFrame(frame);
		outcome.recordDrawFrames(drawFrameCount(effects));
		outcome.recordTerminalOperations(TerminalSchedulerRunner.applyEffects(request.backend, effects));
	}

	static function recordCurrentFrame(request:TuiLiveShellRunRequest, outcome:TuiLiveShellRunOutcome):Void {
		outcome.recordFrame(ChatWidgetShellRenderer.render(request.shell, request.scheduler.currentSize()));
	}

	static function shouldQuitOnKey(request:TuiLiveShellRunRequest, key:TerminalKey):Bool {
		return switch key {
			case TerminalKey.Character("q"):
				request.shell.composer().buffer().length == 0;
			case _:
				false;
		}
	}

	static function shouldInterruptOnKey(request:TuiLiveShellRunRequest, key:TerminalKey):Bool {
		return switch key {
			case TerminalKey.CtrlC:
				request.facade.activeTurn() != null;
			case _:
				false;
		}
	}

	static function drawFrameCount(effects:Array<TerminalSchedulerEffect>):Int {
		var count = 0;
		for (effect in effects) {
			switch effect {
				case TerminalSchedulerEffect.DrawFrame(_):
					count = count + 1;
				case _:
			}
		}
		return count;
	}
}
