package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport that records the outbound JSON-RPC request
	before sending it through a typed in-process JSON-RPC exchange.
**/
class JsonRpcTuiPromptTransport implements TuiPromptTransport {
	final exchange:TuiPromptJsonRpcExchange;
	var lastRequestValue:Null<TuiPromptJsonRpcRequest>;
	var lastResponseValue:Null<TuiPromptJsonRpcResponse>;
	var lastNotificationsValue:Array<TuiPromptJsonRpcNotification>;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
		this.lastNotificationsValue = [];
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		lastRequestValue = request;
		lastResponseValue = null;
		lastNotificationsValue = [];
		final exchangeOutcome = exchange.send(request, envelope);
		if (exchangeOutcome == null || !exchangeOutcome.isAccepted())
			return TuiPromptTransportOutcome.rejected(exchangeOutcome == null ? "missing_exchange_outcome" : exchangeOutcome.code());
		final response = exchangeOutcome.response();
		if (response == null)
			return TuiPromptTransportOutcome.rejected("missing_exchange_response");
		lastResponseValue = response;
		lastNotificationsValue = exchangeOutcome.notifications();
		return TuiPromptTransportOutcome.acceptedWithResponse(response.result,
			TuiPromptJsonRpcNotificationProjector.projectWithStreamEvents(lastNotificationsValue, exchangeOutcome.events()));
	}

	public function lastRequest():Null<TuiPromptJsonRpcRequest> {
		return lastRequestValue;
	}

	public function lastResponse():Null<TuiPromptJsonRpcResponse> {
		return lastResponseValue;
	}

	public function lastNotificationCount():Int {
		return lastNotificationsValue.length;
	}

	public function lastNotificationAt(index:Int):Null<TuiPromptJsonRpcNotification> {
		if (index < 0 || index >= lastNotificationsValue.length)
			return null;
		return lastNotificationsValue[index];
	}

	public function lastNotifications():Array<TuiPromptJsonRpcNotification> {
		return lastNotificationsValue.copy();
	}
}
