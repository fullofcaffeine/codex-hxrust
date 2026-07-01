package codexhx.runtime.tui.appserver;

/**
	Connector-backed JSON-RPC prompt transport that keeps one line transport open.

	Why
	- A live TUI app-server session must survive more than one prompt. The
	  earlier connector-backed transport deliberately closed after every send;
	  this transport models the next session-shaped layer.

	What
	- Connects and materializes the line transport lazily on first send.
	- Reuses the same line transport across subsequent prompt submissions.
	- Converts line outcomes back into the existing typed JSON-RPC transport
	  outcome shape.
	- Exposes explicit close diagnostics without widening the current
	  `TuiAppServerJsonRpcTransport` interface yet.

	How
	- Keeps endpoint/open/attachment reporting in the existing connector seam.
	- Leaves async reader/writer tasks, sockets, credentials, persistence, and
	  model/tool execution for later runtime slices.
**/
class PersistentTuiAppServerJsonRpcLineConnectedTransport implements TuiAppServerJsonRpcTransport {
	final endpoint:TuiAppServerJsonRpcLineEndpoint;
	final connector:DryRunTuiAppServerJsonRpcLineConnector;

	var connectReportValue:TuiAppServerJsonRpcLineConnectReport;
	var lineTransportValue:Null<TuiAppServerJsonRpcLineTransport>;
	var lastLineOutcomeValue:TuiAppServerJsonRpcLineOutcome;
	var lastInterruptLineOutcomeValue:TuiPromptTurnInterruptLineOutcome;
	var lastLateJsonlBatchValue:TuiAppServerJsonRpcLateJsonlBatch;
	var lastLateJsonlPumpResultValue:TuiPromptSubmittedTurnLateJsonlPumpResult;
	var lastLateJsonlDrainResultValue:TuiPromptSubmittedTurnLateJsonlDrainResult;
	var lastCloseReportValue:TuiAppServerJsonRpcLineCloseReport;
	var lastAttemptReportValue:TuiAppServerJsonRpcLineTransportAttemptReport;
	var sendCountValue:Int;
	var closedValue:Bool;

	public function new(endpoint:TuiAppServerJsonRpcLineEndpoint, connector:DryRunTuiAppServerJsonRpcLineConnector) {
		this.endpoint = endpoint;
		this.connector = connector;
		this.connectReportValue = null;
		this.lineTransportValue = null;
		this.lastLineOutcomeValue = null;
		this.lastInterruptLineOutcomeValue = null;
		this.lastLateJsonlBatchValue = null;
		this.lastLateJsonlPumpResultValue = null;
		this.lastLateJsonlDrainResultValue = null;
		this.lastCloseReportValue = null;
		this.lastAttemptReportValue = null;
		this.sendCountValue = 0;
		this.closedValue = false;
	}

	public static function withPersistentStdioSession(endpoint:TuiAppServerJsonRpcLineEndpoint,
			maxInboundLinesPerPrompt:Int):PersistentTuiAppServerJsonRpcLineConnectedTransport {
		return new PersistentTuiAppServerJsonRpcLineConnectedTransport(endpoint,
			DryRunTuiAppServerJsonRpcLineConnector.persistentStdio(maxInboundLinesPerPrompt));
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		lastLineOutcomeValue = null;
		lastAttemptReportValue = null;
		if (closedValue)
			return TuiAppServerJsonRpcTransportOutcome.disconnected("line_connected_transport_closed",
				request == null ? TuiAppServerJsonRpcTransportTranscript.empty() : TuiAppServerJsonRpcTransportTranscript.outbound(request));
		if (request == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_request");
		final outbound = TuiAppServerJsonRpcTransportTranscript.outbound(request);
		if (envelope == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_envelope", outbound);

		final connected = ensureConnected();
		if (connected.length > 0) {
			recordAttempt(null, false);
			return TuiAppServerJsonRpcTransportOutcome.rejected(connected, outbound);
		}
		final transport = lineTransportValue;
		if (transport == null) {
			recordAttempt(null, false);
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_line_transport", outbound);
		}

		final lineOutcome = transport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		lastLineOutcomeValue = lineOutcome;
		sendCountValue = sendCountValue + 1;
		recordAttempt(lineOutcome, true);
		if (lineOutcome == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_line_outcome", outbound);
		final transcript = new TuiAppServerJsonRpcTransportTranscript(request, inboundFramesFromLineOutcome(lineOutcome));
		if (!lineOutcome.isAccepted()) {
			if (lineOutcome.statusText() == TuiAppServerJsonRpcTransportStatus.Disconnected.text())
				return TuiAppServerJsonRpcTransportOutcome.disconnected(lineOutcome.code(), transcript);
			return TuiAppServerJsonRpcTransportOutcome.rejected(lineOutcome.code(), transcript);
		}
		return TuiAppServerJsonRpcTransportOutcome.accepted(lineOutcome.response(), lineOutcome.notifications(), lineOutcome.streamNotifications(),
			lineOutcome.events(), transcript);
	}

	public function sendTurnInterrupt(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptOutcome {
		lastInterruptLineOutcomeValue = null;
		lastAttemptReportValue = null;
		if (closedValue)
			return TuiPromptTurnInterruptOutcome.rejected("line_connected_transport_closed");
		if (request == null)
			return TuiPromptTurnInterruptOutcome.rejected("missing_request");
		if (envelope == null)
			return TuiPromptTurnInterruptOutcome.rejected("missing_envelope");

		final connected = ensureConnected();
		if (connected.length > 0) {
			recordAttempt(null, false);
			return TuiPromptTurnInterruptOutcome.rejected(connected);
		}
		final transport = lineTransportValue;
		if (transport == null) {
			recordAttempt(null, false);
			return TuiPromptTurnInterruptOutcome.rejected("missing_line_transport");
		}

		final lineOutcome = transport.sendInterruptLine(request, envelope, request.messageJson() + "\n");
		lastInterruptLineOutcomeValue = lineOutcome;
		sendCountValue = sendCountValue + 1;
		recordAttempt(null, true);
		if (lineOutcome == null)
			return TuiPromptTurnInterruptOutcome.rejected("missing_line_outcome");
		if (!lineOutcome.isAccepted())
			return TuiPromptTurnInterruptOutcome.rejected(lineOutcome.code());
		return TuiPromptTurnInterruptOutcome.accepted(lineOutcome.response(), lineOutcome.events());
	}

	public function pumpSubmittedTurnLateJsonlBatch(facade:FakeTuiAppServerFacade, maxLines:Int):TuiPromptSubmittedTurnLateJsonlPumpResult {
		lastLateJsonlBatchValue = null;
		lastLateJsonlPumpResultValue = null;
		if (closedValue) {
			lastLateJsonlPumpResultValue = TuiPromptSubmittedTurnLateJsonlPumpResult.lineRejected(TuiAppServerJsonRpcLateJsonlBatch.disconnected("line_connected_transport_closed",
				[]));
			return lastLateJsonlPumpResultValue;
		}
		if (facade == null) {
			lastLateJsonlPumpResultValue = TuiPromptSubmittedTurnLateJsonlPumpResult.lineRejected(TuiAppServerJsonRpcLateJsonlBatch.rejected("missing_facade"));
			return lastLateJsonlPumpResultValue;
		}
		final connected = ensureConnected();
		if (connected.length > 0) {
			lastLateJsonlPumpResultValue = TuiPromptSubmittedTurnLateJsonlPumpResult.lineRejected(TuiAppServerJsonRpcLateJsonlBatch.rejected(connected));
			return lastLateJsonlPumpResultValue;
		}
		final transport = lineTransportValue;
		if (transport == null) {
			lastLateJsonlPumpResultValue = TuiPromptSubmittedTurnLateJsonlPumpResult.lineRejected(TuiAppServerJsonRpcLateJsonlBatch.rejected("missing_line_transport"));
			return lastLateJsonlPumpResultValue;
		}
		final lines = transport.readLateJsonlBatchLines(maxLines);
		lastLateJsonlBatchValue = lines;
		if (lines == null || !lines.isAccepted()) {
			lastLateJsonlPumpResultValue = TuiPromptSubmittedTurnLateJsonlPumpResult.lineRejected(lines);
			return lastLateJsonlPumpResultValue;
		}
		lastLateJsonlPumpResultValue = TuiPromptSubmittedTurnLateJsonlPumpResult.fromBatch(lines, facade.deliverSubmittedTurnJsonlBatchLines(lines.lines()));
		return lastLateJsonlPumpResultValue;
	}

	public function drainSubmittedTurnLateJsonlBatches(facade:FakeTuiAppServerFacade, maxLinesPerBatch:Int,
			maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult {
		lastLateJsonlDrainResultValue = null;
		if (maxLinesPerBatch <= 0) {
			lastLateJsonlDrainResultValue = TuiPromptSubmittedTurnLateJsonlDrainResult.invalid("invalid_late_jsonl_drain_line_count");
			return lastLateJsonlDrainResultValue;
		}
		if (maxBatches <= 0) {
			lastLateJsonlDrainResultValue = TuiPromptSubmittedTurnLateJsonlDrainResult.invalid("invalid_late_jsonl_drain_batch_count");
			return lastLateJsonlDrainResultValue;
		}

		var attemptedBatchCount = 0;
		var acceptedBatchCount = 0;
		var lineCount = 0;
		var notificationCount = 0;
		var appliedNotificationCount = 0;
		var eventsQueued = 0;
		var assistantDeltaCount = 0;
		var completionCount = 0;
		var lastThreadId = "";
		var lastTurnId = "";
		var lastDelta = "";
		var stopPump:TuiPromptSubmittedTurnLateJsonlPumpResult = null;

		for (_ in 0...maxBatches) {
			attemptedBatchCount = attemptedBatchCount + 1;
			stopPump = pumpSubmittedTurnLateJsonlBatch(facade, maxLinesPerBatch);
			if (stopPump == null) {
				lastLateJsonlDrainResultValue = lateJsonlDrainResult(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected,
					"missing_late_jsonl_pump_result", attemptedBatchCount, acceptedBatchCount, lineCount, notificationCount, appliedNotificationCount,
					eventsQueued, assistantDeltaCount, completionCount, stopPump, lastThreadId, lastTurnId, lastDelta);
				return lastLateJsonlDrainResultValue;
			}

			lineCount = lineCount + stopPump.lineCount();
			notificationCount = notificationCount + stopPump.notificationCount();
			appliedNotificationCount = appliedNotificationCount + stopPump.appliedNotificationCount();
			eventsQueued = eventsQueued + stopPump.eventsQueued();
			assistantDeltaCount = assistantDeltaCount + stopPump.assistantDeltaCount();
			completionCount = completionCount + stopPump.completionCount();
			if (stopPump.threadIdText().length > 0)
				lastThreadId = stopPump.threadIdText();
			if (stopPump.turnIdText().length > 0)
				lastTurnId = stopPump.turnIdText();
			if (stopPump.deltaText().length > 0)
				lastDelta = stopPump.deltaText();

			if (!stopPump.acceptedPump()) {
				final status = lateJsonlDrainStopStatus(stopPump.status());
				lastLateJsonlDrainResultValue = lateJsonlDrainResult(status, stopPump.code(), attemptedBatchCount, acceptedBatchCount, lineCount,
					notificationCount, appliedNotificationCount, eventsQueued, assistantDeltaCount, completionCount, stopPump, lastThreadId, lastTurnId,
					lastDelta);
				return lastLateJsonlDrainResultValue;
			}

			acceptedBatchCount = acceptedBatchCount + 1;
			if (stopPump.completionCount() > 0) {
				lastLateJsonlDrainResultValue = lateJsonlDrainResult(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed, "completed", attemptedBatchCount,
					acceptedBatchCount, lineCount, notificationCount, appliedNotificationCount, eventsQueued, assistantDeltaCount, completionCount, stopPump,
					lastThreadId, lastTurnId, lastDelta);
				return lastLateJsonlDrainResultValue;
			}
		}

		lastLateJsonlDrainResultValue = lateJsonlDrainResult(TuiPromptSubmittedTurnLateJsonlDrainStatus.MaxBatchesReached, "max_batches_reached",
			attemptedBatchCount, acceptedBatchCount, lineCount, notificationCount, appliedNotificationCount, eventsQueued, assistantDeltaCount,
			completionCount, stopPump, lastThreadId, lastTurnId, lastDelta);
		return lastLateJsonlDrainResultValue;
	}

	public function drainSubmittedTurnLateJsonl(facade:FakeTuiAppServerFacade, maxLinesPerBatch:Int,
			maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult {
		return drainSubmittedTurnLateJsonlBatches(facade, maxLinesPerBatch, maxBatches);
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		closedValue = true;
		if (lastCloseReportValue != null)
			return lastCloseReportValue;
		final transport = lineTransportValue;
		lineTransportValue = null;
		if (transport == null) {
			lastCloseReportValue = TuiAppServerJsonRpcLineCloseReport.closed(code, 0, 0);
			return lastCloseReportValue;
		}
		lastCloseReportValue = transport.close(code);
		return lastCloseReportValue;
	}

	public function isConnected():Bool {
		return !closedValue && lineTransportValue != null && connectReportValue != null && connectReportValue.isReady();
	}

	public function sendCount():Int {
		return sendCountValue;
	}

	public function lastConnectReport():TuiAppServerJsonRpcLineConnectReport {
		return connectReportValue;
	}

	public function lastLineOutcome():TuiAppServerJsonRpcLineOutcome {
		return lastLineOutcomeValue;
	}

	public function lastInterruptLineOutcome():TuiPromptTurnInterruptLineOutcome {
		return lastInterruptLineOutcomeValue;
	}

	public function lastLateJsonlBatch():TuiAppServerJsonRpcLateJsonlBatch {
		return lastLateJsonlBatchValue;
	}

	public function lastLateJsonlPumpResult():TuiPromptSubmittedTurnLateJsonlPumpResult {
		return lastLateJsonlPumpResultValue;
	}

	public function lastLateJsonlDrainResult():TuiPromptSubmittedTurnLateJsonlDrainResult {
		return lastLateJsonlDrainResultValue;
	}

	public function lastCloseReport():TuiAppServerJsonRpcLineCloseReport {
		return lastCloseReportValue;
	}

	public function lastAttemptReport():TuiAppServerJsonRpcLineTransportAttemptReport {
		return lastAttemptReportValue;
	}

	public function shutdown(code:String):TuiPromptTransportShutdownReport {
		return TuiPromptTransportShutdownReport.fromLineCloseReport(close(code));
	}

	function ensureConnected():String {
		if (lineTransportValue != null)
			return "";
		final report = connector.connect(endpoint);
		connectReportValue = report;
		if (report == null)
			return "missing_connect_report";
		if (!report.isReady())
			return report.code;
		final transport = connector.transportFor(report);
		if (transport == null)
			return "missing_line_transport";
		lineTransportValue = transport;
		lastCloseReportValue = null;
		return "";
	}

	function recordAttempt(lineOutcome:TuiAppServerJsonRpcLineOutcome, transportMaterialized:Bool):Void {
		lastAttemptReportValue = TuiAppServerJsonRpcLineTransportAttemptReport.fromParts(connectReportValue, lineOutcome, null, transportMaterialized);
	}

	static function lateJsonlDrainStopStatus(status:TuiPromptSubmittedTurnLateJsonlPumpStatus):TuiPromptSubmittedTurnLateJsonlDrainStatus {
		if (status == TuiPromptSubmittedTurnLateJsonlPumpStatus.NoData)
			return TuiPromptSubmittedTurnLateJsonlDrainStatus.NoData;
		if (status == TuiPromptSubmittedTurnLateJsonlPumpStatus.LineReadRejected)
			return TuiPromptSubmittedTurnLateJsonlDrainStatus.LineReadRejected;
		return TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected;
	}

	static function lateJsonlDrainResult(status:TuiPromptSubmittedTurnLateJsonlDrainStatus, code:String, attemptedBatchCount:Int, acceptedBatchCount:Int,
			lineCount:Int, notificationCount:Int, appliedNotificationCount:Int, eventsQueued:Int, assistantDeltaCount:Int, completionCount:Int,
			stopPump:TuiPromptSubmittedTurnLateJsonlPumpResult, threadId:String, turnId:String, delta:String):TuiPromptSubmittedTurnLateJsonlDrainResult {
		return new TuiPromptSubmittedTurnLateJsonlDrainResult(status, code, attemptedBatchCount, acceptedBatchCount, lineCount, notificationCount,
			appliedNotificationCount, eventsQueued, assistantDeltaCount, completionCount, stopPump == null ? "" : stopPump.statusText(),
			stopPump == null ? "" : stopPump.code(), stopPump == null ? "" : stopPump.lineStatusText(), stopPump == null ? "" : stopPump.lineCode(),
			stopPump == null ? "" : stopPump.batchStatusText(), stopPump == null ? "" : stopPump.batchCode(), threadId, turnId, delta);
	}

	static function inboundFramesFromLineOutcome(outcome:TuiAppServerJsonRpcLineOutcome):Array<TuiPromptJsonRpcFrame> {
		final frames:Array<TuiPromptJsonRpcFrame> = [];
		if (outcome == null)
			return frames;
		final response = outcome.response();
		if (response != null)
			frames.push(TuiPromptJsonRpcFrame.Response(response));
		for (notification in outcome.streamNotifications())
			frames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		return frames;
	}
}
