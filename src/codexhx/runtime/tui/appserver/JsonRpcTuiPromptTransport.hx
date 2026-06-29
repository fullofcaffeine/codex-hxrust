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
	var lastStreamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	var lastFramesValue:Array<TuiPromptJsonRpcFrame>;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
		this.lastNotificationsValue = [];
		this.lastStreamNotificationsValue = [];
		this.lastFramesValue = [];
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		lastRequestValue = request;
		lastResponseValue = null;
		lastNotificationsValue = [];
		lastStreamNotificationsValue = [];
		lastFramesValue = [TuiPromptJsonRpcFrame.Request(request)];
		final exchangeOutcome = exchange.send(request, envelope);
		if (exchangeOutcome == null || !exchangeOutcome.isAccepted())
			return TuiPromptTransportOutcome.rejected(exchangeOutcome == null ? "missing_exchange_outcome" : exchangeOutcome.code());
		final response = exchangeOutcome.response();
		if (response == null)
			return TuiPromptTransportOutcome.rejected("missing_exchange_response");
		lastResponseValue = response;
		lastNotificationsValue = exchangeOutcome.notifications();
		lastStreamNotificationsValue = exchangeOutcome.streamNotifications();
		final frames = [TuiPromptJsonRpcFrame.Request(request), TuiPromptJsonRpcFrame.Response(response)];
		for (notification in lastStreamNotificationsValue)
			frames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		lastFramesValue = frames;
		return TuiPromptTransportOutcome.acceptedWithResponse(response.result,
			TuiPromptJsonRpcNotificationProjector.projectWithStreamNotifications(lastStreamNotificationsValue, exchangeOutcome.events()));
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

	public function lastStreamNotificationCount():Int {
		return lastStreamNotificationsValue.length;
	}

	public function lastStreamNotificationAt(index:Int):Null<TuiPromptJsonRpcStreamNotification> {
		if (index < 0 || index >= lastStreamNotificationsValue.length)
			return null;
		return lastStreamNotificationsValue[index];
	}

	public function lastStreamNotifications():Array<TuiPromptJsonRpcStreamNotification> {
		return lastStreamNotificationsValue.copy();
	}

	public function lastFrameCount():Int {
		return lastFramesValue.length;
	}

	public function lastFrameAt(index:Int):Null<TuiPromptJsonRpcFrame> {
		if (index < 0 || index >= lastFramesValue.length)
			return null;
		return lastFramesValue[index];
	}

	public function lastFrames():Array<TuiPromptJsonRpcFrame> {
		return lastFramesValue.copy();
	}
}
