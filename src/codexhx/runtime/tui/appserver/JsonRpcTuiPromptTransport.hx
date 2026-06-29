package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport that records the outbound JSON-RPC request
	before sending it through a typed in-process JSON-RPC exchange.
**/
class JsonRpcTuiPromptTransport implements TuiPromptTransport {
	final exchange:TuiPromptJsonRpcExchange;
	var lastRequestValue:Null<TuiPromptJsonRpcRequest>;
	var lastResponseValue:Null<TuiPromptJsonRpcResponse>;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		lastRequestValue = request;
		lastResponseValue = null;
		final exchangeOutcome = exchange.send(request, envelope);
		if (exchangeOutcome == null || !exchangeOutcome.isAccepted())
			return TuiPromptTransportOutcome.rejected(exchangeOutcome == null ? "missing_exchange_outcome" : exchangeOutcome.code());
		final response = exchangeOutcome.response();
		if (response == null)
			return TuiPromptTransportOutcome.rejected("missing_exchange_response");
		lastResponseValue = response;
		return TuiPromptTransportOutcome.acceptedWithResponse(response.result, exchangeOutcome.events());
	}

	public function lastRequest():Null<TuiPromptJsonRpcRequest> {
		return lastRequestValue;
	}

	public function lastResponse():Null<TuiPromptJsonRpcResponse> {
		return lastResponseValue;
	}
}
