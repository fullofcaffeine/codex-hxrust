package codexhx.runtime.tui.smoke;

typedef TuiSmokeTextFormattingPlanFields = {
	final allowTerminalMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeTextFormattingAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTextFormattingPlan {
	public final allowTerminalMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeTextFormattingAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
