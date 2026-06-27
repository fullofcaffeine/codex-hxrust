package codexhx.runtime.tui.smoke;

typedef TuiSmokeCustomPromptPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowPromptCallback:Bool;
	final allowFilesystemMutation:Bool;
	final allowClipboardMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeCustomPromptAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCustomPromptPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowPromptCallback:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowClipboardMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeCustomPromptAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
