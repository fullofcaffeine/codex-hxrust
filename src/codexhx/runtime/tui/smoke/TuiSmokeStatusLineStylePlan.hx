package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusLineStylePlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeStatusLineStyleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusLineStylePlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeStatusLineStyleAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
