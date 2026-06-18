package codexhx.runtime.tui.smoke;

typedef TuiSmokeFrameSchedulerPlanFields = {
	final allowLiveScheduler:Bool;
	final actions:Array<TuiSmokeFrameSchedulerAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFrameSchedulerPlan {
	public final allowLiveScheduler:Bool;
	public final actions:Array<TuiSmokeFrameSchedulerAction>;

	public function enabled():Bool {
		return !allowLiveScheduler && actions.length > 0;
	}
}
