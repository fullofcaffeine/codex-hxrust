package codexhx.runtime.tui.appserver;

import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;

/**
	Deterministic test implementation of `TuiAppServerSession`.

	Production live-shell code depends on the session contract and uses
	`TransportTuiAppServerSession`. This compatibility name remains for focused
	fixtures that exercise stale responses and queued events directly.
**/
class FakeTuiAppServerFacade extends TransportTuiAppServerSession {
	public function new(shell:ChatWidgetShellState, ?promptTransport:TuiPromptTransport) {
		super(shell, promptTransport);
	}
}
