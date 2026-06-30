package codexhx.runtime.tui.appserver;

/**
	Typed diagnostic report for one connector-backed line transport attempt.
**/
class TuiAppServerJsonRpcLineTransportAttemptReport {
	public final connectStatus:TuiAppServerJsonRpcLineConnectStatus;
	public final connectCodeValue:String;
	public final transportMaterialized:Bool;
	public final lineOutcomeRecorded:Bool;
	public final lineStatus:TuiAppServerJsonRpcTransportStatus;
	public final lineCodeValue:String;
	public final closeReportRecorded:Bool;
	public final closeState:TuiAppServerJsonRpcLineTransportState;
	public final closeCodeValue:String;
	public final outboundLineCountValue:Int;
	public final inboundLineCountValue:Int;

	public function new(connectStatus:TuiAppServerJsonRpcLineConnectStatus, connectCode:String, transportMaterialized:Bool, lineOutcomeRecorded:Bool,
			lineStatus:TuiAppServerJsonRpcTransportStatus, lineCode:String, closeReportRecorded:Bool, closeState:TuiAppServerJsonRpcLineTransportState,
			closeCode:String, outboundLineCount:Int, inboundLineCount:Int) {
		this.connectStatus = connectStatus;
		this.connectCodeValue = connectCode;
		this.transportMaterialized = transportMaterialized;
		this.lineOutcomeRecorded = lineOutcomeRecorded;
		this.lineStatus = lineStatus;
		this.lineCodeValue = lineCode;
		this.closeReportRecorded = closeReportRecorded;
		this.closeState = closeState;
		this.closeCodeValue = closeCode;
		this.outboundLineCountValue = outboundLineCount;
		this.inboundLineCountValue = inboundLineCount;
	}

	public static function fromParts(connectReport:TuiAppServerJsonRpcLineConnectReport, lineOutcome:TuiAppServerJsonRpcLineOutcome,
			closeReport:TuiAppServerJsonRpcLineCloseReport, transportMaterialized:Bool):TuiAppServerJsonRpcLineTransportAttemptReport {
		final lineRecorded = lineOutcome != null;
		final closeRecorded = closeReport != null;
		return new TuiAppServerJsonRpcLineTransportAttemptReport(connectReport == null ? TuiAppServerJsonRpcLineConnectStatus.Refused : connectReport.status,
			connectReport == null ? "missing_connect_report" : connectReport.code, transportMaterialized, lineRecorded,
			lineRecorded ? lineOutcome.status : TuiAppServerJsonRpcTransportStatus.Rejected, lineRecorded ? lineOutcome.code() : "", closeRecorded,
			closeRecorded ? closeReport.state : TuiAppServerJsonRpcLineTransportState.Closed, closeRecorded ? closeReport.code : "",
			closeRecorded ? closeReport.outboundLineCount : 0, closeRecorded ? closeReport.inboundLineCount : 0);
	}

	public function connectStatusText():String {
		return connectStatus.text();
	}

	public function connectCode():String {
		return connectCodeValue;
	}

	public function hasLineOutcome():Bool {
		return lineOutcomeRecorded;
	}

	public function lineStatusText():String {
		return lineOutcomeRecorded ? lineStatus.text() : "";
	}

	public function lineCode():String {
		return lineCodeValue;
	}

	public function hasCloseReport():Bool {
		return closeReportRecorded;
	}

	public function closeStateText():String {
		return closeReportRecorded ? closeState.text() : "";
	}

	public function closeCode():String {
		return closeCodeValue;
	}

	public function outboundLineCount():Int {
		return outboundLineCountValue;
	}

	public function inboundLineCount():Int {
		return inboundLineCountValue;
	}
}
