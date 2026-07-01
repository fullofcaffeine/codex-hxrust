package codexhx.runtime.tui.appserver;

/**
	Runtime-facing JSON-RPC transport contract for app-server prompt requests.
**/
interface TuiAppServerJsonRpcTransport {
	function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome;
	function sendTurnInterrupt(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptOutcome;
	function drainSubmittedTurnLateJsonl(facade:FakeTuiAppServerFacade, maxLinesPerBatch:Int, maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult;
	function shutdown(code:String):TuiPromptTransportShutdownReport;
}
