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
