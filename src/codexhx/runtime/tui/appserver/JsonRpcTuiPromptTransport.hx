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
	var lastWireRecordsValue:Array<TuiPromptJsonRpcFrameRecord>;
	var lastCorrelationValue:TuiPromptJsonRpcFrameCorrelation;
	var lastStreamScopeValue:TuiPromptJsonRpcStreamScopeReport;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
		this.lastNotificationsValue = [];
		this.lastStreamNotificationsValue = [];
		this.lastFramesValue = [];
		this.lastWireRecordsValue = [];
		this.lastCorrelationValue = TuiPromptJsonRpcFrameCorrelation.fromFrames([]);
		this.lastStreamScopeValue = TuiPromptJsonRpcStreamScopeReport.fromNotifications(null, null, []);
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		lastRequestValue = request;
		lastResponseValue = null;
		lastNotificationsValue = [];
		lastStreamNotificationsValue = [];
		replaceLastFrames([TuiPromptJsonRpcFrame.Request(request)]);
		final exchangeOutcome = exchange.send(request, envelope);
		if (exchangeOutcome == null || !exchangeOutcome.isAccepted())
			return TuiPromptTransportOutcome.rejected(exchangeOutcome == null ? "missing_exchange_outcome" : exchangeOutcome.code());
		final response = exchangeOutcome.response();
		if (response == null)
			return TuiPromptTransportOutcome.rejected("missing_exchange_response");
		final responseFrames = [TuiPromptJsonRpcFrame.Request(request), TuiPromptJsonRpcFrame.Response(response)];
		final responseCorrelation = TuiPromptJsonRpcFrameCorrelation.fromFrames(responseFrames);
		if (!responseCorrelation.isComplete()) {
			replaceLastFrames(responseFrames);
			return TuiPromptTransportOutcome.rejected(responseCorrelation.code());
		}
		final exchangeStreamNotifications = exchangeOutcome.streamNotifications();
		final streamFrames = responseFrames.copy();
		for (notification in exchangeStreamNotifications)
			streamFrames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		final streamScope = TuiPromptJsonRpcStreamScopeReport.fromNotifications(envelope.threadId, response.result.turnId, exchangeStreamNotifications);
		if (!streamScope.isAccepted()) {
			replaceLastFrames(streamFrames);
			return TuiPromptTransportOutcome.rejected(streamScope.code());
		}
		lastResponseValue = response;
		lastNotificationsValue = exchangeOutcome.notifications();
		lastStreamNotificationsValue = exchangeStreamNotifications;
		final frames = responseFrames.copy();
		for (notification in lastStreamNotificationsValue)
			frames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		replaceLastFrames(frames);
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

	public function lastWireRecordCount():Int {
		return lastWireRecordsValue.length;
	}

	public function lastWireRecordAt(index:Int):Null<TuiPromptJsonRpcFrameRecord> {
		if (index < 0 || index >= lastWireRecordsValue.length)
			return null;
		return lastWireRecordsValue[index];
	}

	public function lastWireRecords():Array<TuiPromptJsonRpcFrameRecord> {
		return lastWireRecordsValue.copy();
	}

	public function lastWireJsonLines():String {
		return TuiPromptJsonRpcFrameCodec.jsonLines(lastWireRecordsValue);
	}

	public function lastCorrelation():TuiPromptJsonRpcFrameCorrelation {
		return lastCorrelationValue;
	}

	public function lastStreamScope():TuiPromptJsonRpcStreamScopeReport {
		return lastStreamScopeValue;
	}

	function replaceLastFrames(frames:Array<TuiPromptJsonRpcFrame>):Void {
		lastFramesValue = frames;
		lastWireRecordsValue = TuiPromptJsonRpcFrameCodec.records(frames);
		lastCorrelationValue = TuiPromptJsonRpcFrameCorrelation.fromFrames(frames);
		final response = firstResponse(frames);
		lastStreamScopeValue = response == null ? TuiPromptJsonRpcStreamScopeReport.fromNotifications(null, null,
			[]) : TuiPromptJsonRpcStreamScopeReport.fromNotifications(firstRequestThreadId(frames), response.result.turnId, streamNotifications(frames));
	}

	function firstResponse(frames:Array<TuiPromptJsonRpcFrame>):Null<TuiPromptJsonRpcResponse> {
		if (frames == null)
			return null;
		for (frame in frames) {
			switch frame {
				case TuiPromptJsonRpcFrame.Response(response):
					return response;
				case _:
			}
		}
		return null;
	}

	function firstRequestThreadId(frames:Array<TuiPromptJsonRpcFrame>):Null<codexhx.protocol.ThreadId> {
		if (frames == null)
			return null;
		for (frame in frames) {
			switch frame {
				case TuiPromptJsonRpcFrame.Request(request):
					return request.params.threadId;
				case _:
			}
		}
		return null;
	}

	function streamNotifications(frames:Array<TuiPromptJsonRpcFrame>):Array<TuiPromptJsonRpcStreamNotification> {
		final out:Array<TuiPromptJsonRpcStreamNotification> = [];
		if (frames == null)
			return out;
		for (frame in frames) {
			switch frame {
				case TuiPromptJsonRpcFrame.StreamNotification(notification):
					out.push(notification);
				case _:
			}
		}
		return out;
	}
}
