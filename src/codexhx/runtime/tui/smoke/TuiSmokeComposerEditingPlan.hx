package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerEditingPlanFields = {
	final allowLiveInput:Bool;
	final actions:Array<TuiSmokeComposerEditingAction>;
}

class TuiSmokeComposerEditingPlan {
	public final allowLiveInput:Bool;
	public final actions:Array<TuiSmokeComposerEditingAction>;

	public function new(fields:TuiSmokeComposerEditingPlanFields) {
		this.allowLiveInput = fields.allowLiveInput;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveInput && actions.length > 0;
	}
}
