package codexhx.runtime.tui.appserver;

/**
	One ordered JSON-RPC frame observed by the prompt transport.
**/
enum TuiPromptJsonRpcFrame {
	Request(request:TuiPromptJsonRpcRequest);
	Response(response:TuiPromptJsonRpcResponse);
	StreamNotification(notification:TuiPromptJsonRpcStreamNotification);
}
