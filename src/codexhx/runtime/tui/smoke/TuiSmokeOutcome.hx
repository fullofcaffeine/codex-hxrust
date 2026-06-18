package codexhx.runtime.tui.smoke;

typedef TuiSmokeOutcomeFields = {
	final ok:Bool;
	final code:String;
	final exit:TuiSmokeExitKind;
	final snapshot:String;
	final terminalRestored:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeOutcome {
	public final ok:Bool;
	public final code:String;
	public final exit:TuiSmokeExitKind;
	public final snapshot:String;
	public final terminalRestored:Bool;
}
