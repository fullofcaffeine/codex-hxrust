package codexhx.runtime.tui.appserver;

import codexhx.runtime.tui.chatwidget.ChatWidgetShellRenderer;
import codexhx.runtime.tui.terminal.TerminalBackend;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalSchedulerEvent;
import codexhx.runtime.tui.terminal.TerminalSchedulerRunner;
import codexhx.runtime.tui.terminal.TerminalSize;

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
}
