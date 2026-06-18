package codexhx.runtime.tui.smoke;

typedef TuiSmokeLoopOutcomeFields = {
	final ok:Bool;
	final code:String;
	final exit:TuiSmokeExitKind;
	final snapshot:String;
	final trace:String;
	final renderCount:Int;
	final appEventLogCount:Int;
	final appServerEventCount:Int;
	final appServerRequestCount:Int;
	final appServerRejectedRequestCount:Int;
	final appServerResolutionCount:Int;
	final appServerStaleResolutionCount:Int;
	final terminalRestored:Bool;
}

class TuiSmokeLoopOutcome {
	public final ok:Bool;
	public final code:String;
	public final exit:TuiSmokeExitKind;
	public final snapshot:String;
	public final trace:String;
	public final renderCount:Int;
	public final appEventLogCount:Int;
	public final appServerEventCount:Int;
	public final appServerRequestCount:Int;
	public final appServerRejectedRequestCount:Int;
	public final appServerResolutionCount:Int;
	public final appServerStaleResolutionCount:Int;
	public final terminalRestored:Bool;

	public function new(fields:TuiSmokeLoopOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.exit = fields.exit == null ? TuiSmokeExitKind.Unknown : fields.exit;
		this.snapshot = fields.snapshot == null ? "" : fields.snapshot;
		this.trace = fields.trace == null ? "" : fields.trace;
		this.renderCount = fields.renderCount;
		this.appEventLogCount = fields.appEventLogCount;
		this.appServerEventCount = fields.appServerEventCount;
		this.appServerRequestCount = fields.appServerRequestCount;
		this.appServerRejectedRequestCount = fields.appServerRejectedRequestCount;
		this.appServerResolutionCount = fields.appServerResolutionCount;
		this.appServerStaleResolutionCount = fields.appServerStaleResolutionCount;
		this.terminalRestored = fields.terminalRestored;
	}
}
