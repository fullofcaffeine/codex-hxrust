package codexhx.runtime.tui.appserver;

/**
	Prompt turn acceptance policy for live-ish JSON-RPC prompt transports.
**/
enum abstract TuiPromptTurnAcceptanceMode(String) to String {
	final Complete = "complete";
	final Submitted = "submitted";

	public function text():String {
		return this;
	}
}
