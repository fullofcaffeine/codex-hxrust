package codexhx.runtime.tui.appserver;

/**
	Typed validation report for a future app-server line transport endpoint.
**/
class TuiAppServerJsonRpcLineEndpointReport {
	public final status:TuiAppServerJsonRpcLineEndpointStatus;
	public final code:String;
	public final launchPlan:Null<TuiAppServerJsonRpcProcessLaunchPlan>;
	public final host:String;
	public final port:Int;

	public function new(status:TuiAppServerJsonRpcLineEndpointStatus, code:String, launchPlan:Null<TuiAppServerJsonRpcProcessLaunchPlan>, host:String,
			port:Int) {
		this.status = status;
		this.code = normalize(code);
		this.launchPlan = launchPlan;
		this.host = normalize(host);
		this.port = port;
	}

	public static function inspect(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineEndpointReport {
		return switch endpoint {
			case Stdio(plan):
				inspectStdio(plan);
			case TcpSocket(host, port):
				inspectSocket(host, port);
			case Unsupported(code):
				new TuiAppServerJsonRpcLineEndpointReport(TuiAppServerJsonRpcLineEndpointStatus.Unsupported, normalizeCode(code, "unsupported"), null, "", 0);
		}
	}

	public static function invalid(code:String):TuiAppServerJsonRpcLineEndpointReport {
		return new TuiAppServerJsonRpcLineEndpointReport(TuiAppServerJsonRpcLineEndpointStatus.Invalid, normalizeCode(code, "invalid"), null, "", 0);
	}

	public function isReady():Bool {
		return status == TuiAppServerJsonRpcLineEndpointStatus.StdioReady || status == TuiAppServerJsonRpcLineEndpointStatus.SocketReady;
	}

	public function statusText():String {
		return status.text();
	}

	public function command():String {
		return launchPlan == null ? "" : launchPlan.command;
	}

	public function cwd():String {
		return launchPlan == null ? "" : launchPlan.cwd;
	}

	public function argCount():Int {
		return launchPlan == null ? 0 : launchPlan.argCount();
	}

	public function argAt(index:Int):String {
		return launchPlan == null ? "" : launchPlan.argAt(index);
	}

	public function envCount():Int {
		return launchPlan == null ? 0 : launchPlan.envCount();
	}

	public function envAt(index:Int):Null<TuiAppServerJsonRpcProcessEnvVar> {
		return launchPlan == null ? null : launchPlan.envAt(index);
	}

	static function inspectStdio(plan:TuiAppServerJsonRpcProcessLaunchPlan):TuiAppServerJsonRpcLineEndpointReport {
		if (plan == null)
			return invalid("missing_launch_plan");
		if (!plan.isValid())
			return invalid(plan.validationCode());
		return new TuiAppServerJsonRpcLineEndpointReport(TuiAppServerJsonRpcLineEndpointStatus.StdioReady, "ready", plan, "", 0);
	}

	static function inspectSocket(host:String, port:Int):TuiAppServerJsonRpcLineEndpointReport {
		final normalizedHost = normalize(host);
		if (normalizedHost.length == 0)
			return invalid("missing_socket_host");
		if (port <= 0 || port > 65535)
			return invalid("invalid_socket_port");
		return new TuiAppServerJsonRpcLineEndpointReport(TuiAppServerJsonRpcLineEndpointStatus.SocketReady, "ready", null, normalizedHost, port);
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeCode(value:String, fallback:String):String {
		final normalized = normalize(value);
		return normalized.length == 0 ? fallback : normalized;
	}
}
