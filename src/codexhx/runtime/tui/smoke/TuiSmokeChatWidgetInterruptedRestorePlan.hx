package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetInterruptedRestorePlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeChatWidgetInterruptedRestoreAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetInterruptedRestorePlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeChatWidgetInterruptedRestoreAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
