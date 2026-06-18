package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerSubmissionPlanFields = {
	final allowLiveDispatch:Bool;
	final actions:Array<TuiSmokeComposerSubmissionAction>;
}

class TuiSmokeComposerSubmissionPlan {
	public final allowLiveDispatch:Bool;
	public final actions:Array<TuiSmokeComposerSubmissionAction>;

	public function new(fields:TuiSmokeComposerSubmissionPlanFields) {
		this.allowLiveDispatch = fields.allowLiveDispatch;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveDispatch && actions.length > 0;
	}
}
