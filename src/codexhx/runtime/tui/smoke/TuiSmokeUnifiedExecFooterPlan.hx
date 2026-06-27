package codexhx.runtime.tui.smoke;

typedef TuiSmokeUnifiedExecFooterPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeUnifiedExecFooterAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeUnifiedExecFooterPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeUnifiedExecFooterAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
