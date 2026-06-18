package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetComposerRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowLiveDispatch:Bool;
	final actions:Array<TuiSmokeChatWidgetComposerRenderAction>;
}

class TuiSmokeChatWidgetComposerRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowLiveDispatch:Bool;
	public final actions:Array<TuiSmokeChatWidgetComposerRenderAction>;

	public function new(fields:TuiSmokeChatWidgetComposerRenderPlanFields) {
		this.allowLiveTerminal = fields.allowLiveTerminal;
		this.allowRatatuiRender = fields.allowRatatuiRender;
		this.allowLiveDispatch = fields.allowLiveDispatch;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowLiveDispatch && actions.length > 0;
	}
}
