package codexhx.runtime.tui.smoke;

typedef TuiSmokeMultiSelectPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowFilesystemMutation:Bool;
	final allowClipboardMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final allowAppEventDelivery:Bool;
	final items:Array<TuiSmokeMultiSelectItem>;
	final actions:Array<TuiSmokeMultiSelectAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMultiSelectPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowClipboardMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final allowAppEventDelivery:Bool;
	public final items:Array<TuiSmokeMultiSelectItem>;
	public final actions:Array<TuiSmokeMultiSelectAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
