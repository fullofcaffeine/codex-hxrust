package codexhx.runtime.tui.appserver;

/**
	Terminal status for a typed app-server readiness interaction.
**/
enum abstract TuiAppServerReadinessInteractionStatus(String) to String {
	final Drained = "drained";
	final NoPendingSubmittedTurn = "no_pending_submitted_turn";

	public function text():String {
		return this;
	}
}
