package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetStreamStatusPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeChatWidgetStreamStatusAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetStreamStatusPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeChatWidgetStreamStatusAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
