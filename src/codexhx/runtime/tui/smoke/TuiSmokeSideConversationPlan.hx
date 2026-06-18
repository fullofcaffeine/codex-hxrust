package codexhx.runtime.tui.smoke;

typedef TuiSmokeSideConversationPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeSideConversationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSideConversationPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeSideConversationAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
