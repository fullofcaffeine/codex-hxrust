package codexhx.runtime.tui.appserver;

/**
	App-server JSON-RPC transport backed by the dry-run line endpoint connector.
**/
class DryRunTuiAppServerJsonRpcLineConnectedTransport implements TuiAppServerJsonRpcTransport {
	final endpoint:TuiAppServerJsonRpcLineEndpoint;

	var lastConnectReportValue:TuiAppServerJsonRpcLineConnectReport;
	var lastLineOutcomeValue:TuiAppServerJsonRpcLineOutcome;
	var lastCloseReportValue:TuiAppServerJsonRpcLineCloseReport;

	public function new(endpoint:TuiAppServerJsonRpcLineEndpoint) {
		this.endpoint = endpoint;
		this.lastConnectReportValue = null;
		this.lastLineOutcomeValue = null;
		this.lastCloseReportValue = null;
	}

	public static function stdio(plan:TuiAppServerJsonRpcProcessLaunchPlan):DryRunTuiAppServerJsonRpcLineConnectedTransport {
		return new DryRunTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(plan));
	}

	public static function socket(host:String, port:Int):DryRunTuiAppServerJsonRpcLineConnectedTransport {
		return new DryRunTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.TcpSocket(host, port));
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		lastConnectReportValue = null;
		lastLineOutcomeValue = null;
		lastCloseReportValue = null;
		if (request == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_request");
		final outbound = TuiAppServerJsonRpcTransportTranscript.outbound(request);
		if (envelope == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_envelope", outbound);
		final connector = new DryRunTuiAppServerJsonRpcLineConnector();
		final connectReport = connector.connect(endpoint);
		lastConnectReportValue = connectReport;
		if (connectReport == null || !connectReport.isReady())
			return TuiAppServerJsonRpcTransportOutcome.rejected(connectReport == null ? "missing_connect_report" : connectReport.code, outbound);
		final lineTransport = connector.transportFor(connectReport);
		if (lineTransport == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_line_transport", outbound);
		final lineOutcome = lineTransport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		lastLineOutcomeValue = lineOutcome;
		lastCloseReportValue = lineTransport.close("line_connected_transport_done");
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
