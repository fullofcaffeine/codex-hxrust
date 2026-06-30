package codexhx.runtime.tui.appserver;

/**
	Credential-free app-server JSON-RPC transport backed by an in-process exchange.
**/
class FakeTuiAppServerJsonRpcTransport implements TuiAppServerJsonRpcTransport {
	final exchange:TuiPromptJsonRpcExchange;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		if (request == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_request");
		if (envelope == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_envelope");
		final outcome = exchange.send(request, envelope);
		if (outcome == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_exchange_outcome");
		if (!outcome.isAccepted())
			return TuiAppServerJsonRpcTransportOutcome.rejected(outcome.code());
		return TuiAppServerJsonRpcTransportOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events());
	}
}
