package codexhx.runtime.tui.appserver;

/**
	Ordered stream notifications emitted by the fake prompt JSON-RPC exchange.
**/
enum TuiPromptJsonRpcStreamNotification {
	Turn(notification:TuiPromptJsonRpcNotification);
	AgentMessageDelta(notification:TuiPromptAgentMessageDeltaNotification);
}
