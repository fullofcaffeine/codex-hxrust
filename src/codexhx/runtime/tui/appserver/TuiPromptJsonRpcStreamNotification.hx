package codexhx.runtime.tui.appserver;

/**
	Ordered stream notifications emitted by the fake prompt JSON-RPC exchange.
**/
enum TuiPromptJsonRpcStreamNotification {
	Turn(notification:TuiPromptJsonRpcNotification);
	UserMessageCompleted(notification:TuiPromptUserMessageCompletedNotification);
	AgentMessageStarted(notification:TuiPromptAgentMessageStartedNotification);
	AgentMessageDelta(notification:TuiPromptAgentMessageDeltaNotification);
	RawResponseItemCompleted(notification:TuiPromptRawResponseItemCompletedNotification);
	AgentMessageCompleted(notification:TuiPromptAgentMessageCompletedNotification);
}
