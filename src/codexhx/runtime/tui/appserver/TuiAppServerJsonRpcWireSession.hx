package codexhx.runtime.tui.appserver;

/**
	Runtime-facing app-server JSON-RPC wire session for prompt requests.
**/
interface TuiAppServerJsonRpcWireSession {
	function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope,
		outboundRecord:TuiPromptJsonRpcFrameRecord):TuiAppServerJsonRpcWireOutcome;
}
