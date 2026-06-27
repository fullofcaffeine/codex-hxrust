package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusSurfacePreviewPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeStatusSurfacePreviewAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusSurfacePreviewPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeStatusSurfacePreviewAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
