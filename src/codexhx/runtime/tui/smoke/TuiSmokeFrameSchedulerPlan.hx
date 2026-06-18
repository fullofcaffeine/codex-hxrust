package codexhx.runtime.tui.smoke;

typedef TuiSmokeFrameSchedulerPlanFields = {
	final allowLiveScheduler:Bool;
	final actions:Array<TuiSmokeFrameSchedulerAction>;
}

class TuiSmokeFrameSchedulerPlan {
	public final allowLiveScheduler:Bool;
	public final actions:Array<TuiSmokeFrameSchedulerAction>;

	public function new(fields:TuiSmokeFrameSchedulerPlanFields) {
		this.allowLiveScheduler = fields.allowLiveScheduler;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveScheduler && actions.length > 0;
	}
}
