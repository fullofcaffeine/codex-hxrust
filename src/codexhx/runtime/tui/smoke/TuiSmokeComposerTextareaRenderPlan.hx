package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerTextareaRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final actions:Array<TuiSmokeComposerTextareaRenderAction>;
}

class TuiSmokeComposerTextareaRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final actions:Array<TuiSmokeComposerTextareaRenderAction>;

	public function new(fields:TuiSmokeComposerTextareaRenderPlanFields) {
		this.allowLiveTerminal = fields.allowLiveTerminal;
		this.allowRatatuiRender = fields.allowRatatuiRender;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && actions.length > 0;
	}
}
