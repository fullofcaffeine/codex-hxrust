package codexhx.runtime.tui.appserver;

/**
	Credential-free JSON-RPC exchange seam for the minimal live prompt path.
**/
interface TuiPromptJsonRpcExchange {
	function send(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome;
}
