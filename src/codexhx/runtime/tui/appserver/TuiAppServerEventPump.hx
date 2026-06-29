package codexhx.runtime.tui.appserver;

import codexhx.runtime.tui.chatwidget.ChatWidgetShellRenderer;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellEffect;
import codexhx.runtime.tui.terminal.TerminalBackend;
import codexhx.runtime.tui.terminal.TerminalInputEvent;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalSchedulerEvent;
import codexhx.runtime.tui.terminal.TerminalSchedulerRunner;
import codexhx.runtime.tui.terminal.TerminalSize;
import codexhx.protocol.RequestId;

/**
	Pumps typed fake app-server events into the live shell redraw path.

	The fake facade owns session/thread state mutation. This pump owns the next
	layer: effects that request redraw become scheduler events, rendered frames,
	and backend operations through the same path used by terminal resize/input.
**/
class TuiAppServerEventPump {
	final facade:FakeTuiAppServerFacade;
	final scheduler:TerminalRedrawScheduler;
	final backend:TerminalBackend;

	public function new(facade:FakeTuiAppServerFacade, scheduler:TerminalRedrawScheduler, backend:TerminalBackend) {
		this.facade = facade;
		this.scheduler = scheduler;
		this.backend = backend;
	}

	public function drain(policy:TuiAppServerPumpPolicy):TuiAppServerPumpOutcome {
		final outcome = new TuiAppServerPumpOutcome();
		final safePolicy = policy == null ? TuiAppServerPumpPolicy.lossless() : policy;
		if (safePolicy.cancellationRequested) {
			outcome.markCancelled();
			return outcome;
		}

		var processed = 0;
		while (facade.queuedCount() > 0 && safePolicy.allowsAnother(processed)) {
			final event = facade.shiftQueued();
			if (event != null) {
				final effects = facade.receive(event);
				outcome.recordEvent(effects);
				requestDraws(effects);
				processed = processed + 1;
			}
		}

		if (facade.queuedCount() > 0)
			outcome.markBackpressure();
		flushFrame(outcome);
		return outcome;
	}

	public function submitComposerInput(input:TerminalInputEvent, requestId:RequestId, policy:TuiAppServerPumpPolicy):TuiPromptSubmitInteraction {
		final shellEffects = facade.shell().applyInput(input);
		final submitResult = submitPromptFromShellEffects(shellEffects, requestId, input);
		requestShellDraws(shellEffects);
		final outcome = drain(policy);
		return new TuiPromptSubmitInteraction(shellEffects, submitResult, outcome);
	}

	function submitPromptFromShellEffects(shellEffects:Array<ChatWidgetShellEffect>, requestId:RequestId,
			input:TerminalInputEvent):Null<TuiPromptSubmitResult> {
		for (effect in shellEffects) {
			switch effect {
				case ChatWidgetShellEffect.PromptSubmitted(text):
					return facade.submitPrompt(requestId, text);
				case _:
			}
		}
		if (isSubmitInput(input))
			return TuiPromptSubmitResult.refused(TuiPromptSubmitStatus.EmptyPrompt);
		return null;
	}

	function requestShellDraws(effects:Array<ChatWidgetShellEffect>):Void {
		if (effects == null)
			return;
		for (effect in effects) {
			switch effect {
				case ChatWidgetShellEffect.DrawRequested:
					scheduler.handle(TerminalSchedulerEvent.DrawRequested);
				case ChatWidgetShellEffect.ExitRequested(reason):
					scheduler.handle(TerminalSchedulerEvent.AppExit(reason));
				case _:
			}
		}
	}

	function requestDraws(effects:Array<TuiAppServerShellEffect>):Void {
		if (effects == null)
			return;
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.DrawRequested:
					scheduler.handle(TerminalSchedulerEvent.DrawRequested);
				case _:
			}
		}
	}

	function flushFrame(outcome:TuiAppServerPumpOutcome):Void {
		final frame = ChatWidgetShellRenderer.render(facade.shell(), scheduler.currentSize());
		final schedulerEffects = scheduler.flush(frame);
		outcome.recordSchedulerEffects(schedulerEffects);
		outcome.recordTerminalOperations(TerminalSchedulerRunner.applyEffects(backend, schedulerEffects));
	}

	public function currentSize():TerminalSize {
		return scheduler.currentSize();
	}

	static function isSubmitInput(input:TerminalInputEvent):Bool {
		return switch input {
			case TerminalInputEvent.Submit:
				true;
			case _:
				false;
		}
	}
}
