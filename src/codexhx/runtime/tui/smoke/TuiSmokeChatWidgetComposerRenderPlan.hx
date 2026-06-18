package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetComposerRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowLiveDispatch:Bool;
	final actions:Array<TuiSmokeChatWidgetComposerRenderAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetComposerRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowLiveDispatch:Bool;
	public final actions:Array<TuiSmokeChatWidgetComposerRenderAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowLiveDispatch && actions.length > 0;
	}
}
