package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport that records the outbound JSON-RPC request
	before sending it through a typed app-server JSON-RPC transport.
**/
class JsonRpcTuiPromptTransport implements TuiPromptTransport {
	final appServerTransport:TuiAppServerJsonRpcTransport;
	var lastRequestValue:Null<TuiPromptJsonRpcRequest>;
	var lastResponseValue:Null<TuiPromptJsonRpcResponse>;
	var lastNotificationsValue:Array<TuiPromptJsonRpcNotification>;
	var lastStreamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	var lastFramesValue:Array<TuiPromptJsonRpcFrame>;
	var lastWireRecordsValue:Array<TuiPromptJsonRpcFrameRecord>;
	var lastCorrelationValue:TuiPromptJsonRpcFrameCorrelation;
	var lastStreamScopeValue:TuiPromptJsonRpcStreamScopeReport;
	var lastTurnLifecycleValue:TuiPromptTurnLifecycleReport;

	public function new(?appServerTransport:TuiAppServerJsonRpcTransport) {
		this.appServerTransport = appServerTransport == null ? new FakeTuiAppServerJsonRpcTransport() : appServerTransport;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
		this.lastNotificationsValue = [];
		this.lastStreamNotificationsValue = [];
		this.lastFramesValue = [];
		this.lastWireRecordsValue = [];
		this.lastCorrelationValue = TuiPromptJsonRpcFrameCorrelation.fromFrames([]);
		this.lastStreamScopeValue = TuiPromptJsonRpcStreamScopeReport.fromNotifications(null, null, []);
		this.lastTurnLifecycleValue = TuiPromptTurnLifecycleReport.fromNotifications(null, []);
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
		final transportOutcome = appServerTransport.sendPrompt(request, envelope);
		if (transportOutcome == null || !transportOutcome.isAccepted())
			return TuiPromptTransportOutcome.rejected(transportOutcome == null ? "missing_transport_outcome" : transportOutcome.code());
		final response = transportOutcome.response();
		if (response == null)
			return TuiPromptTransportOutcome.rejected("missing_transport_response");
		final responseFrames = [TuiPromptJsonRpcFrame.Request(request), TuiPromptJsonRpcFrame.Response(response)];
		final responseCorrelation = TuiPromptJsonRpcFrameCorrelation.fromFrames(responseFrames);
		if (!responseCorrelation.isComplete()) {
			replaceLastFrames(responseFrames);
			return TuiPromptTransportOutcome.rejected(responseCorrelation.code());
		}
		final exchangeStreamNotifications = transportOutcome.streamNotifications();
		final streamFrames = responseFrames.copy();
		for (notification in exchangeStreamNotifications)
			streamFrames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		final streamScope = TuiPromptJsonRpcStreamScopeReport.fromNotifications(envelope.threadId, response.result.turnId, exchangeStreamNotifications);
		if (!streamScope.isAccepted()) {
			replaceLastFrames(streamFrames);
			return TuiPromptTransportOutcome.rejected(streamScope.code());
		}
		final turnLifecycle = TuiPromptTurnLifecycleReport.fromNotifications(response.result.turnId, exchangeStreamNotifications);
		if (!turnLifecycle.isComplete()) {
			replaceLastFrames(streamFrames);
			return TuiPromptTransportOutcome.rejected(turnLifecycle.code());
		}
		lastResponseValue = response;
		lastNotificationsValue = transportOutcome.notifications();
		lastStreamNotificationsValue = exchangeStreamNotifications;
		final frames = responseFrames.copy();
		for (notification in lastStreamNotificationsValue)
			frames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		replaceLastFrames(frames);
		return TuiPromptTransportOutcome.acceptedWithResponse(response.result,
			TuiPromptJsonRpcNotificationProjector.projectWithStreamNotifications(lastStreamNotificationsValue, transportOutcome.events()));
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

	public function lastTurnLifecycle():TuiPromptTurnLifecycleReport {
		return lastTurnLifecycleValue;
	}

	function replaceLastFrames(frames:Array<TuiPromptJsonRpcFrame>):Void {
		lastFramesValue = frames;
		lastWireRecordsValue = TuiPromptJsonRpcFrameCodec.records(frames);
		lastCorrelationValue = TuiPromptJsonRpcFrameCorrelation.fromFrames(frames);
		final response = firstResponse(frames);
		lastStreamScopeValue = response == null ? TuiPromptJsonRpcStreamScopeReport.fromNotifications(null, null,
			[]) : TuiPromptJsonRpcStreamScopeReport.fromNotifications(firstRequestThreadId(frames), response.result.turnId, streamNotifications(frames));
		lastTurnLifecycleValue = response == null ? TuiPromptTurnLifecycleReport.fromNotifications(null,
			[]) : TuiPromptTurnLifecycleReport.fromNotifications(response.result.turnId, streamNotifications(frames));
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
