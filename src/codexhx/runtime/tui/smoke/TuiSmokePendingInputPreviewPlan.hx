package codexhx.runtime.tui.smoke;

typedef TuiSmokePendingInputPreviewPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokePendingInputPreviewAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePendingInputPreviewPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokePendingInputPreviewAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
