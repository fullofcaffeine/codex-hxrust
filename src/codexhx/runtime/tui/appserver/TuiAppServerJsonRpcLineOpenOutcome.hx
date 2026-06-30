package codexhx.runtime.tui.appserver;

/**
	Typed result from the app-server line native-open boundary.
**/
class TuiAppServerJsonRpcLineOpenOutcome {
	public final status:TuiAppServerJsonRpcLineOpenOutcomeStatus;
	public final code:String;
	public final connectionLabel:String;
	public final connectionIndex:Int;

	final intentReportValue:TuiAppServerJsonRpcLineOpenIntentReport;

	public function new(status:TuiAppServerJsonRpcLineOpenOutcomeStatus, code:String, connectionLabel:String, connectionIndex:Int,
			intentReport:TuiAppServerJsonRpcLineOpenIntentReport) {
		this.status = status;
		this.code = normalizeCode(code, status.text());
		this.connectionLabel = normalize(connectionLabel);
		this.connectionIndex = connectionIndex < 0 ? 0 : connectionIndex;
		this.intentReportValue = intentReport;
	}

	public static function opened(connectionLabel:String, connectionIndex:Int,
			intentReport:TuiAppServerJsonRpcLineOpenIntentReport):TuiAppServerJsonRpcLineOpenOutcome {
		return new TuiAppServerJsonRpcLineOpenOutcome(TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, "opened", connectionLabel, connectionIndex,
			intentReport);
	}

	public static function refused(intentReport:TuiAppServerJsonRpcLineOpenIntentReport):TuiAppServerJsonRpcLineOpenOutcome {
		final code = intentReport == null ? "missing_open_intent" : intentReport.code;
		return new TuiAppServerJsonRpcLineOpenOutcome(TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused, code, "", 0, intentReport);
	}

	public function isOpened():Bool {
		return status == TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened;
	}

	public function statusText():String {
		return status.text();
	}

	public function intentReport():TuiAppServerJsonRpcLineOpenIntentReport {
		return intentReportValue;
	}

	public function intentKindText():String {
		return intentReportValue == null ? "" : intentReportValue.kindText();
	}

	public function endpointStatusText():String {
		return intentReportValue == null ? "" : intentReportValue.endpointStatusText();
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeCode(value:String, fallback:String):String {
		final normalized = normalize(value);
		return normalized.length == 0 ? fallback : normalized;
	}
}
