package codexhx.runtime.tui.appserver;

/**
	App-server JSON-RPC transport backed by the dry-run line endpoint connector.
**/
class DryRunTuiAppServerJsonRpcLineConnectedTransport implements TuiAppServerJsonRpcTransport {
	final endpoint:TuiAppServerJsonRpcLineEndpoint;
	final rejectionCode:String;

	var lastConnectReportValue:TuiAppServerJsonRpcLineConnectReport;
	var lastLineOutcomeValue:TuiAppServerJsonRpcLineOutcome;
	var lastCloseReportValue:TuiAppServerJsonRpcLineCloseReport;
	var lastAttemptReportValue:TuiAppServerJsonRpcLineTransportAttemptReport;

	public function new(endpoint:TuiAppServerJsonRpcLineEndpoint, rejectionCode:String) {
		this.endpoint = endpoint;
		this.rejectionCode = rejectionCode;
		this.lastConnectReportValue = null;
		this.lastLineOutcomeValue = null;
		this.lastCloseReportValue = null;
		this.lastAttemptReportValue = null;
	}

	public static function stdio(plan:TuiAppServerJsonRpcProcessLaunchPlan):DryRunTuiAppServerJsonRpcLineConnectedTransport {
		return stdioWithRejection(plan, "");
	}

	public static function stdioWithRejection(plan:TuiAppServerJsonRpcProcessLaunchPlan, rejectionCode:String):DryRunTuiAppServerJsonRpcLineConnectedTransport {
		return new DryRunTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(plan), rejectionCode);
	}

	public static function socket(host:String, port:Int):DryRunTuiAppServerJsonRpcLineConnectedTransport {
		return socketWithRejection(host, port, "");
	}

	public static function socketWithRejection(host:String, port:Int, rejectionCode:String):DryRunTuiAppServerJsonRpcLineConnectedTransport {
		return new DryRunTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.TcpSocket(host, port), rejectionCode);
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		lastConnectReportValue = null;
		lastLineOutcomeValue = null;
		lastCloseReportValue = null;
		lastAttemptReportValue = null;
		if (request == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_request");
		final outbound = TuiAppServerJsonRpcTransportTranscript.outbound(request);
		if (envelope == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_envelope", outbound);
		final connector:TuiAppServerJsonRpcLineConnector = new DryRunTuiAppServerJsonRpcLineConnector();
		final connectReport = connector.connect(endpoint);
		lastConnectReportValue = connectReport;
		if (connectReport == null || !connectReport.isReady()) {
			recordAttempt(connectReport, null, null, false);
			return TuiAppServerJsonRpcTransportOutcome.rejected(connectReport == null ? "missing_connect_report" : connectReport.code, outbound);
		}
		final lineTransport = materializeLineTransport(connector, connectReport);
		if (lineTransport == null) {
			recordAttempt(connectReport, null, null, false);
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_line_transport", outbound);
		}
		final lineOutcome = lineTransport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		lastLineOutcomeValue = lineOutcome;
		lastCloseReportValue = lineTransport.close("line_connected_transport_done");
		recordAttempt(connectReport, lineOutcome, lastCloseReportValue, true);
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

	public function lastConnectReport():TuiAppServerJsonRpcLineConnectReport {
		return lastConnectReportValue;
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

	function recordAttempt(connectReport:TuiAppServerJsonRpcLineConnectReport, lineOutcome:TuiAppServerJsonRpcLineOutcome,
			closeReport:TuiAppServerJsonRpcLineCloseReport, transportMaterialized:Bool):Void {
		lastAttemptReportValue = TuiAppServerJsonRpcLineTransportAttemptReport.fromParts(connectReport, lineOutcome, closeReport, transportMaterialized);
	}

	function materializeLineTransport(connector:TuiAppServerJsonRpcLineConnector,
			connectReport:TuiAppServerJsonRpcLineConnectReport):Null<TuiAppServerJsonRpcLineTransport> {
		if (rejectionCode.length == 0)
			return connector.transportFor(connectReport);
		if (connectReport == null || !connectReport.isReady())
			return null;
		return new FakeTuiAppServerJsonRpcLineTransport(new DryRunRejectingTuiPromptJsonRpcExchange(rejectionCode));
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
