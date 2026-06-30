package codexhx.runtime.tui.appserver;

/**
	Runtime-facing JSON-RPC transport contract for app-server prompt requests.
**/
interface TuiAppServerJsonRpcTransport {
	function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome;
	function sendTurnInterrupt(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptOutcome;
	function shutdown(code:String):TuiPromptTransportShutdownReport;
}
