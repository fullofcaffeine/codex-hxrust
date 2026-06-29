package codexhx.runtime.tui.appserver;

/**
	Selected app-protocol turn statuses emitted by the minimal live prompt path.
**/
enum abstract TuiPromptTurnStatus(String) to String {
	final InProgress = "inProgress";
	final Completed = "completed";

	public function text():String {
		return this;
	}
}
