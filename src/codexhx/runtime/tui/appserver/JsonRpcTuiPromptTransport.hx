package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport that records the outbound JSON-RPC request
	before sending it through a typed app-server JSON-RPC transport.
**/
class JsonRpcTuiPromptTransport implements TuiPromptTransport {
	final appServerTransport:TuiAppServerJsonRpcTransport;
	final acceptanceMode:TuiPromptTurnAcceptanceMode;
	var lastRequestValue:Null<TuiPromptJsonRpcRequest>;
	var lastResponseValue:Null<TuiPromptJsonRpcResponse>;
	var lastNotificationsValue:Array<TuiPromptJsonRpcNotification>;
	var lastStreamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	var lastFramesValue:Array<TuiPromptJsonRpcFrame>;
	var lastWireRecordsValue:Array<TuiPromptJsonRpcFrameRecord>;
	var lastCorrelationValue:TuiPromptJsonRpcFrameCorrelation;
	var lastStreamScopeValue:TuiPromptJsonRpcStreamScopeReport;
	var lastTurnLifecycleValue:TuiPromptTurnLifecycleReport;
	var lastInterruptRequestValue:Null<TuiPromptTurnInterruptRequest>;
	var lastInterruptResponseValue:Null<TuiPromptTurnInterruptResponse>;
	var lastInterruptOutcomeValue:TuiPromptTurnInterruptOutcome;

	public function new(?appServerTransport:TuiAppServerJsonRpcTransport, ?acceptanceMode:TuiPromptTurnAcceptanceMode) {
		this.appServerTransport = appServerTransport == null ? new FakeTuiAppServerJsonRpcTransport() : appServerTransport;
		this.acceptanceMode = acceptanceMode == null ? TuiPromptTurnAcceptanceMode.Complete : acceptanceMode;
		this.lastRequestValue = null;
		this.lastResponseValue = null;
		this.lastNotificationsValue = [];
		this.lastStreamNotificationsValue = [];
		this.lastFramesValue = [];
		this.lastWireRecordsValue = [];
		this.lastCorrelationValue = TuiPromptJsonRpcFrameCorrelation.fromFrames([]);
		this.lastStreamScopeValue = TuiPromptJsonRpcStreamScopeReport.fromNotifications(null, null, []);
		this.lastTurnLifecycleValue = TuiPromptTurnLifecycleReport.fromNotifications(null, []);
		this.lastInterruptRequestValue = null;
		this.lastInterruptResponseValue = null;
		this.lastInterruptOutcomeValue = TuiPromptTurnInterruptOutcome.rejected("not_sent");
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
		final transcript = transportOutcome == null ? TuiAppServerJsonRpcTransportTranscript.outbound(request) : transportOutcome.transcript();
		if (transportOutcome == null || !transportOutcome.isAccepted()) {
			replaceLastFrames(transcript.frames());
			return TuiPromptTransportOutcome.rejected(transportOutcome == null ? "missing_transport_outcome" : transportOutcome.code());
		}
		final response = transportOutcome.response();
		if (response == null) {
			replaceLastFrames(transcript.frames());
			return TuiPromptTransportOutcome.rejected("missing_transport_response");
		}
		final transcriptFrames = transcript.frames();
		final responseCorrelation = TuiPromptJsonRpcFrameCorrelation.fromFrames(transcriptFrames);
		if (!responseCorrelation.isComplete()) {
			replaceLastFrames(transcriptFrames);
			return TuiPromptTransportOutcome.rejected(responseCorrelation.code());
		}
		final exchangeStreamNotifications = transportOutcome.streamNotifications();
		final streamScope = TuiPromptJsonRpcStreamScopeReport.fromNotifications(envelope.threadId, response.result.turnId, exchangeStreamNotifications);
		if (!streamScope.isAccepted()) {
			replaceLastFrames(transcriptFrames);
			return TuiPromptTransportOutcome.rejected(streamScope.code());
		}
		final turnLifecycle = TuiPromptTurnLifecycleReport.fromNotifications(response.result.turnId, exchangeStreamNotifications);
		if (!turnAccepted(turnLifecycle)) {
			replaceLastFrames(transcriptFrames);
			return TuiPromptTransportOutcome.rejected(turnLifecycle.code());
		}
		lastResponseValue = response;
		lastNotificationsValue = transportOutcome.notifications();
		lastStreamNotificationsValue = exchangeStreamNotifications;
		replaceLastFrames(transcriptFrames);
		return TuiPromptTransportOutcome.acceptedWithResponse(response.result,
			TuiPromptJsonRpcNotificationProjector.projectWithStreamNotifications(lastStreamNotificationsValue, transportOutcome.events()));
	}

	public function interruptTurn(envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptOutcome {
		if (envelope == null) {
			lastInterruptRequestValue = null;
			lastInterruptResponseValue = null;
			lastInterruptOutcomeValue = TuiPromptTurnInterruptOutcome.rejected("missing_envelope");
			return lastInterruptOutcomeValue;
		}
		final request = TuiPromptTurnInterruptRequest.fromEnvelope(envelope);
		lastInterruptRequestValue = request;
		lastInterruptResponseValue = null;
		final outcome = appServerTransport.sendTurnInterrupt(request, envelope);
		lastInterruptOutcomeValue = outcome == null ? TuiPromptTurnInterruptOutcome.rejected("missing_interrupt_outcome") : outcome;
		if (lastInterruptOutcomeValue.isAccepted())
			lastInterruptResponseValue = lastInterruptOutcomeValue.response();
		return lastInterruptOutcomeValue;
	}

	public function drainSubmittedTurnLateJsonl(facade:FakeTuiAppServerFacade, maxLinesPerBatch:Int,
			maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult {
		return appServerTransport.drainSubmittedTurnLateJsonl(facade, maxLinesPerBatch, maxBatches);
	}

	public function shutdown(code:String):TuiPromptTransportShutdownReport {
		return appServerTransport.shutdown(code);
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

	public function turnAcceptanceModeText():String {
		return acceptanceMode.text();
	}

	public function lastInterruptRequest():Null<TuiPromptTurnInterruptRequest> {
		return lastInterruptRequestValue;
	}

	public function lastInterruptResponse():Null<TuiPromptTurnInterruptResponse> {
		return lastInterruptResponseValue;
	}

	public function lastInterruptOutcome():TuiPromptTurnInterruptOutcome {
		return lastInterruptOutcomeValue;
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

	function turnAccepted(lifecycle:TuiPromptTurnLifecycleReport):Bool {
		if (lifecycle == null)
			return false;
		if (lifecycle.isComplete())
			return true;
		return acceptanceMode == TuiPromptTurnAcceptanceMode.Submitted && lifecycle.isSubmitted();
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
