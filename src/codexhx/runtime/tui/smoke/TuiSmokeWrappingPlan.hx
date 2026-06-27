package codexhx.runtime.tui.smoke;

typedef TuiSmokeWrappingPlanFields = {
	final allowTerminalMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeWrappingAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeWrappingPlan {
	public final allowTerminalMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeWrappingAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
