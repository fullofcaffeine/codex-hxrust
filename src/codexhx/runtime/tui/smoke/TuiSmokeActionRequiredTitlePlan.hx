package codexhx.runtime.tui.smoke;

typedef TuiSmokeActionRequiredTitlePlanFields = {
	final allowTerminalTitleMutation:Bool;
	final allowRatatuiRender:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeActionRequiredTitleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeActionRequiredTitlePlan {
	public final allowTerminalTitleMutation:Bool;
	public final allowRatatuiRender:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeActionRequiredTitleAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
