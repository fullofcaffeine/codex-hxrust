package codexhx.runtime.tui.appserver;

/**
	Structured endpoint-to-transport connection diagnostics.
**/
class TuiAppServerJsonRpcLineConnectReport {
	public final status:TuiAppServerJsonRpcLineConnectStatus;
	public final code:String;
	public final connectionLabel:String;
	public final connectionIndex:Int;
	public final transportOpen:Bool;

	final endpointReportValue:TuiAppServerJsonRpcLineEndpointReport;
	final openOutcomeValue:TuiAppServerJsonRpcLineOpenOutcome;
	final attachmentReportValue:TuiAppServerJsonRpcLineTransportAttachmentReport;

	public function new(status:TuiAppServerJsonRpcLineConnectStatus, code:String, connectionLabel:String, connectionIndex:Int, transportOpen:Bool,
			endpointReport:TuiAppServerJsonRpcLineEndpointReport, openOutcome:TuiAppServerJsonRpcLineOpenOutcome,
			attachmentReport:TuiAppServerJsonRpcLineTransportAttachmentReport) {
		this.status = status;
		this.code = normalizeCode(code, status.text());
		this.connectionLabel = normalize(connectionLabel);
		this.connectionIndex = connectionIndex < 0 ? 0 : connectionIndex;
		this.transportOpen = transportOpen;
		this.endpointReportValue = endpointReport;
		this.openOutcomeValue = openOutcome;
		this.attachmentReportValue = attachmentReport;
	}

	public static function fromParts(endpointReport:TuiAppServerJsonRpcLineEndpointReport, openOutcome:TuiAppServerJsonRpcLineOpenOutcome,
			attachmentReport:TuiAppServerJsonRpcLineTransportAttachmentReport):TuiAppServerJsonRpcLineConnectReport {
		if (endpointReport == null)
			return refused("missing_endpoint_report", endpointReport, openOutcome, attachmentReport);
		if (openOutcome == null || !openOutcome.isOpened())
			return refused(openOutcome == null ? endpointReport.code : openOutcome.code, endpointReport, openOutcome, attachmentReport);
		if (attachmentReport == null || !attachmentReport.isReady())
			return refused(attachmentReport == null ? "missing_attachment_report" : attachmentReport.code, endpointReport, openOutcome, attachmentReport);
		return new TuiAppServerJsonRpcLineConnectReport(TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", attachmentReport.connectionLabel,
			attachmentReport.connectionIndex, attachmentReport.transportOpen, endpointReport, openOutcome, attachmentReport);
	}

	public static function refused(code:String, endpointReport:TuiAppServerJsonRpcLineEndpointReport, openOutcome:TuiAppServerJsonRpcLineOpenOutcome,
			attachmentReport:TuiAppServerJsonRpcLineTransportAttachmentReport):TuiAppServerJsonRpcLineConnectReport {
		final label = attachmentReport == null ? "" : attachmentReport.connectionLabel;
		final index = attachmentReport == null ? 0 : attachmentReport.connectionIndex;
		return new TuiAppServerJsonRpcLineConnectReport(TuiAppServerJsonRpcLineConnectStatus.Refused, code, label, index, false, endpointReport, openOutcome,
			attachmentReport);
	}

	public function isReady():Bool {
		return status == TuiAppServerJsonRpcLineConnectStatus.Ready;
	}

	public function statusText():String {
		return status.text();
	}

	public function endpointReport():TuiAppServerJsonRpcLineEndpointReport {
		return endpointReportValue;
	}

	public function openOutcome():TuiAppServerJsonRpcLineOpenOutcome {
		return openOutcomeValue;
	}

	public function attachmentReport():TuiAppServerJsonRpcLineTransportAttachmentReport {
		return attachmentReportValue;
	}

	public function endpointStatusText():String {
		return endpointReportValue == null ? "" : endpointReportValue.statusText();
	}

	public function intentKindText():String {
		return openOutcomeValue == null ? "" : openOutcomeValue.intentKindText();
	}

	public function openStatusText():String {
		return openOutcomeValue == null ? "" : openOutcomeValue.statusText();
	}

	public function attachmentStatusText():String {
		return attachmentReportValue == null ? "" : attachmentReportValue.statusText();
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeCode(value:String, fallback:String):String {
		final normalized = normalize(value);
		return normalized.length == 0 ? fallback : normalized;
	}
}
