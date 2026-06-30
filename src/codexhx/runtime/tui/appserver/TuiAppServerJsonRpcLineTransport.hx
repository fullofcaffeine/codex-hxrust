package codexhx.runtime.tui.appserver;

/**
	Line-oriented app-server JSON-RPC transport for prompt requests.
**/
interface TuiAppServerJsonRpcLineTransport {
	function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome;
}
