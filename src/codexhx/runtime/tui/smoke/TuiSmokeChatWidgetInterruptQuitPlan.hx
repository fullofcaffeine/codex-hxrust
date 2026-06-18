package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetInterruptQuitPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeChatWidgetInterruptQuitAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetInterruptQuitPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeChatWidgetInterruptQuitAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
