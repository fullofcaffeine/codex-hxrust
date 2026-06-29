package codexhx.runtime.tui.appserver;

/**
	App-server JSON-RPC notifications emitted by the minimal live prompt path.
**/
enum abstract TuiPromptJsonRpcNotificationMethod(String) to String {
	final TurnStarted = "turn/started";
	final TurnCompleted = "turn/completed";

	public function text():String {
		return this;
	}
}
