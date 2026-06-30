package codexhx.runtime.tui.appserver;

/**
	Runtime-facing JSON-RPC transport contract for app-server prompt requests.
**/
interface TuiAppServerJsonRpcTransport {
	function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome;
	function shutdown(code:String):TuiPromptTransportShutdownReport;
}
