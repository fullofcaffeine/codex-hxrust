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
	final launchPlanValue:Null<TuiAppServerJsonRpcProcessLaunchPlan>;
	final socketHostValue:String;
	final socketPortValue:Int;

	public function new(status:TuiAppServerJsonRpcLineOpenOutcomeStatus, code:String, connectionLabel:String, connectionIndex:Int,
			intentReport:TuiAppServerJsonRpcLineOpenIntentReport, launchPlan:Null<TuiAppServerJsonRpcProcessLaunchPlan>, socketHost:String, socketPort:Int) {
		this.status = status;
		this.code = normalizeCode(code, status.text());
		this.connectionLabel = normalize(connectionLabel);
		this.connectionIndex = connectionIndex < 0 ? 0 : connectionIndex;
		this.intentReportValue = intentReport;
		this.launchPlanValue = launchPlan;
		this.socketHostValue = normalize(socketHost);
		this.socketPortValue = socketPort < 0 ? 0 : socketPort;
	}

	public static function opened(connectionLabel:String, connectionIndex:Int, intentReport:TuiAppServerJsonRpcLineOpenIntentReport,
			intent:TuiAppServerJsonRpcLineOpenIntent):TuiAppServerJsonRpcLineOpenOutcome {
		return new TuiAppServerJsonRpcLineOpenOutcome(TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, "opened", connectionLabel, connectionIndex,
			intentReport, launchPlanFromIntent(intent), socketHostFromIntent(intent), socketPortFromIntent(intent));
	}

	public static function refused(intentReport:TuiAppServerJsonRpcLineOpenIntentReport):TuiAppServerJsonRpcLineOpenOutcome {
		final code = intentReport == null ? "missing_open_intent" : intentReport.code;
		return new TuiAppServerJsonRpcLineOpenOutcome(TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused, code, "", 0, intentReport, null, "", 0);
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

	public function hasLaunchPlan():Bool {
		return launchPlan() != null;
	}

	public function launchPlan():Null<TuiAppServerJsonRpcProcessLaunchPlan> {
		return launchPlanValue;
	}

	public function hasSocketTarget():Bool {
		return socketHost().length > 0 && socketPort() > 0;
	}

	public function socketHost():String {
		return socketHostValue;
	}

	public function socketPort():Int {
		return socketPortValue;
	}

	static function launchPlanFromIntent(intent:TuiAppServerJsonRpcLineOpenIntent):Null<TuiAppServerJsonRpcProcessLaunchPlan> {
		return switch intent {
			case SpawnStdio(plan):
				plan;
			case ConnectTcp(_, _) | Refuse(_):
				null;
		}
	}

	static function socketHostFromIntent(intent:TuiAppServerJsonRpcLineOpenIntent):String {
		return switch intent {
			case ConnectTcp(host, _):
				normalize(host);
			case SpawnStdio(_) | Refuse(_):
				"";
		}
	}

	static function socketPortFromIntent(intent:TuiAppServerJsonRpcLineOpenIntent):Int {
		return switch intent {
			case ConnectTcp(_, port):
				port < 0 ? 0 : port;
			case SpawnStdio(_) | Refuse(_):
				0;
		}
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeCode(value:String, fallback:String):String {
		final normalized = normalize(value);
		return normalized.length == 0 ? fallback : normalized;
	}
}
