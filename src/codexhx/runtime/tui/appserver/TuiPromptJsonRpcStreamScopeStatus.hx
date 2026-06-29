package codexhx.runtime.tui.appserver;

/**
	Scope validation status for prompt JSON-RPC stream notifications.
**/
enum abstract TuiPromptJsonRpcStreamScopeStatus(String) to String {
	final Complete = "complete";
	final Empty = "empty";
	final ThreadMismatch = "thread_mismatch";
	final TurnMismatch = "turn_mismatch";

	public function text():String {
		return this;
	}
}
