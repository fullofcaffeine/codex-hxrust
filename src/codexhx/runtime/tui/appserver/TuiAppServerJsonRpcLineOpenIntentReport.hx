package codexhx.runtime.tui.appserver;

/**
	Inspectable report for the line transport native-open intent.
**/
class TuiAppServerJsonRpcLineOpenIntentReport {
	public final kind:TuiAppServerJsonRpcLineOpenIntentKind;
	public final code:String;
	public final endpointStatus:TuiAppServerJsonRpcLineEndpointStatus;
	public final command:String;
	public final cwd:String;
	public final host:String;
	public final port:Int;
	public final argCount:Int;
	public final envCount:Int;

	public function new(kind:TuiAppServerJsonRpcLineOpenIntentKind, code:String, endpointStatus:TuiAppServerJsonRpcLineEndpointStatus, command:String,
			cwd:String, host:String, port:Int, argCount:Int, envCount:Int) {
		this.kind = kind;
		this.code = normalizeCode(code);
		this.endpointStatus = endpointStatus;
		this.command = normalize(command);
		this.cwd = normalize(cwd);
		this.host = normalize(host);
		this.port = port;
		this.argCount = argCount < 0 ? 0 : argCount;
		this.envCount = envCount < 0 ? 0 : envCount;
	}

	public static function fromEndpoint(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineOpenIntentReport {
		return fromIntent(intentFromEndpoint(endpoint));
	}

	public static function intentFromEndpoint(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineOpenIntent {
		final report = TuiAppServerJsonRpcLineEndpointReport.inspect(endpoint);
		if (!report.isReady())
			return TuiAppServerJsonRpcLineOpenIntent.Refuse(report);
		if (report.status == TuiAppServerJsonRpcLineEndpointStatus.StdioReady)
			return TuiAppServerJsonRpcLineOpenIntent.SpawnStdio(report.launchPlan);
		return TuiAppServerJsonRpcLineOpenIntent.ConnectTcp(report.host, report.port);
	}

	public static function fromIntent(intent:TuiAppServerJsonRpcLineOpenIntent):TuiAppServerJsonRpcLineOpenIntentReport {
		return switch intent {
			case SpawnStdio(plan):
				if (plan == null) {
					new TuiAppServerJsonRpcLineOpenIntentReport(TuiAppServerJsonRpcLineOpenIntentKind.Refuse, "missing_launch_plan",
						TuiAppServerJsonRpcLineEndpointStatus.Invalid, "", "", "", 0, 0, 0);
				} else {
					new TuiAppServerJsonRpcLineOpenIntentReport(TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio, "ready",
						TuiAppServerJsonRpcLineEndpointStatus.StdioReady, plan.command, plan.cwd, "", 0, plan.argCount(), plan.envCount());
				}
			case ConnectTcp(host, port):
				final endpointReport = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.TcpSocket(host, port));
				if (endpointReport.isReady()) {
					new TuiAppServerJsonRpcLineOpenIntentReport(TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp, "ready",
						TuiAppServerJsonRpcLineEndpointStatus.SocketReady, "", "", endpointReport.host, endpointReport.port, 0, 0);
				} else {
					refusal(endpointReport);
				}
			case Refuse(report):
				refusal(report);
		}
	}

	public function kindText():String {
		return kind.text();
	}

	public function endpointStatusText():String {
		return endpointStatus.text();
	}

	public function isActionable():Bool {
		return kind == TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio || kind == TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp;
	}

	static function refusal(report:TuiAppServerJsonRpcLineEndpointReport):TuiAppServerJsonRpcLineOpenIntentReport {
		if (report == null)
			return new TuiAppServerJsonRpcLineOpenIntentReport(TuiAppServerJsonRpcLineOpenIntentKind.Refuse, "missing_endpoint_report",
				TuiAppServerJsonRpcLineEndpointStatus.Invalid, "", "", "", 0, 0, 0);
		return new TuiAppServerJsonRpcLineOpenIntentReport(TuiAppServerJsonRpcLineOpenIntentKind.Refuse, report.code, report.status, report.command(),
			report.cwd(), report.host, report.port, report.argCount(), report.envCount());
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeCode(value:String):String {
		final normalized = normalize(value);
		return normalized.length == 0 ? "refused" : normalized;
	}
}
