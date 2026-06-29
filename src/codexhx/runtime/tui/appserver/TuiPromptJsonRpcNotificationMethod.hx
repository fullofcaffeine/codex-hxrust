package codexhx.runtime.tui.appserver;

/**
	App-server JSON-RPC notifications emitted by the minimal live prompt path.
**/
enum abstract TuiPromptJsonRpcNotificationMethod(String) to String {
	final ThreadStatusChanged = "thread/status/changed";
	final TurnStarted = "turn/started";
	final TurnCompleted = "turn/completed";
	final AgentMessageDelta = "item/agentMessage/delta";
	final ItemStarted = "item/started";
	final ItemCompleted = "item/completed";
	final RawResponseItemCompleted = "rawResponseItem/completed";

	public function text():String {
		return this;
	}
}
