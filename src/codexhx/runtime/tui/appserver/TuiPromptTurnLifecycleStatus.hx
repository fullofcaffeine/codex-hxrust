package codexhx.runtime.tui.appserver;

/**
	Completeness status for the selected prompt turn in JSON-RPC stream events.
**/
enum abstract TuiPromptTurnLifecycleStatus(String) to String {
	final Complete = "complete";
	final MissingStarted = "missing_started";
	final MissingCompleted = "missing_completed";
	final MissingStartedAndCompleted = "missing_started_and_completed";

	public function text():String {
		return this;
	}
}
