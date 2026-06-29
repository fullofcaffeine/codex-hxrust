package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport that records the outbound JSON-RPC request
	before delegating to an in-process fake response transport.
**/
class JsonRpcTuiPromptTransport implements TuiPromptTransport {
	final delegate:TuiPromptTransport;
	var lastRequestValue:Null<TuiPromptJsonRpcRequest>;

	public function new(?delegate:TuiPromptTransport) {
		this.delegate = delegate == null ? new EchoTuiPromptTransport() : delegate;
		this.lastRequestValue = null;
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		lastRequestValue = TuiPromptJsonRpcRequest.turnStart(envelope);
		return delegate.submitPrompt(envelope);
	}

	public function lastRequest():Null<TuiPromptJsonRpcRequest> {
		return lastRequestValue;
	}
}
