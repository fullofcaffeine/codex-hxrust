package codexhx.runtime.tui.smoke;

typedef TuiSmokeOutcomeFields = {
	final ok:Bool;
	final code:String;
	final exit:TuiSmokeExitKind;
	final snapshot:String;
	final terminalRestored:Bool;
}

class TuiSmokeOutcome {
	public final ok:Bool;
	public final code:String;
	public final exit:TuiSmokeExitKind;
	public final snapshot:String;
	public final terminalRestored:Bool;

	public function new(fields:TuiSmokeOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.exit = fields.exit == null ? TuiSmokeExitKind.Unknown : fields.exit;
		this.snapshot = fields.snapshot == null ? "" : fields.snapshot;
		this.terminalRestored = fields.terminalRestored;
	}
}
