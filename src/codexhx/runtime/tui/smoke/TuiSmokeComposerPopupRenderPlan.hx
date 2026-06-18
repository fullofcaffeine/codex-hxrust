package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final actions:Array<TuiSmokeComposerPopupRenderAction>;
}

class TuiSmokeComposerPopupRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final actions:Array<TuiSmokeComposerPopupRenderAction>;

	public function new(fields:TuiSmokeComposerPopupRenderPlanFields) {
		this.allowLiveTerminal = fields.allowLiveTerminal;
		this.allowRatatuiRender = fields.allowRatatuiRender;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && actions.length > 0;
	}
}
