package codexhx.runtime.tui.smoke;

typedef TuiSmokeTextAreaPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowClipboardMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final allowAppServerDelivery:Bool;
	final actions:Array<TuiSmokeTextAreaAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTextAreaPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowClipboardMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerDelivery:Bool;
	public final actions:Array<TuiSmokeTextAreaAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
