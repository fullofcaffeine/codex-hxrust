package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadReadSessionPlanFields = {
	final allowAppServerMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeThreadReadSessionAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadReadSessionPlan {
	public final allowAppServerMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeThreadReadSessionAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
