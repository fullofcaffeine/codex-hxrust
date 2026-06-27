package codexhx.runtime.tui.smoke;

typedef TuiSmokeFileSearchPopupPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeFileSearchPopupAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFileSearchPopupPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeFileSearchPopupAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
