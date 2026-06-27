package codexhx.runtime.tui.smoke;

typedef TuiSmokeCommandPopupPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowClipboardMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final catalog:Array<TuiSmokeCommandPopupItem>;
	final actions:Array<TuiSmokeCommandPopupAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCommandPopupPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowClipboardMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final catalog:Array<TuiSmokeCommandPopupItem>;
	public final actions:Array<TuiSmokeCommandPopupAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
