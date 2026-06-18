package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetActiveStreamPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeChatWidgetActiveStreamAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetActiveStreamPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeChatWidgetActiveStreamAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
