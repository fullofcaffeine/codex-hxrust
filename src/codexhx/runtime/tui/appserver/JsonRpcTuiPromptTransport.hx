package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport that records the outbound JSON-RPC request
	before delegating to an in-process fake response transport.
**/
class JsonRpcTuiPromptTransport implements TuiPromptTransport {
	final delegate:TuiPromptTransport;
	var lastRequestValue:Null<TuiPromptJsonRpcRequest>;
	var lastResponseValue:Null<TuiPromptJsonRpcResponse>;

	public function new(?delegate:TuiPromptTransport) {
		this.delegate = delegate == null ? new EchoTuiPromptTransport() : delegate;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		lastRequestValue = request;
		lastResponseValue = null;
		final outcome = delegate.submitPrompt(envelope);
		if (outcome != null && outcome.isAccepted() && outcome.response() != null)
			lastResponseValue = TuiPromptJsonRpcResponse.turnStart(request, outcome.response());
		return outcome;
	}

	public function lastRequest():Null<TuiPromptJsonRpcRequest> {
		return lastRequestValue;
	}

	public function lastResponse():Null<TuiPromptJsonRpcResponse> {
		return lastResponseValue;
	}
}
