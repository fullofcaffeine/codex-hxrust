package codexhx.runtime.tui.smoke;

typedef TuiSmokeListSelectionPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowClipboardMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeListSelectionAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeListSelectionPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowClipboardMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeListSelectionAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
