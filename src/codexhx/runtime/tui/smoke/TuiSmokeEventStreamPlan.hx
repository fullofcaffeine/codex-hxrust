package codexhx.runtime.tui.smoke;

typedef TuiSmokeEventStreamPlanFields = {
	final initialState:TuiSmokeEventStreamBrokerState;
	final actions:Array<TuiSmokeEventStreamAction>;
	final allowLiveEventSource:Bool;
}

class TuiSmokeEventStreamPlan {
	public final initialState:TuiSmokeEventStreamBrokerState;
	public final actions:Array<TuiSmokeEventStreamAction>;
	public final allowLiveEventSource:Bool;

	public function new(fields:TuiSmokeEventStreamPlanFields) {
		this.initialState = fields.initialState == null ? TuiSmokeEventStreamBrokerState.Unknown : fields.initialState;
		this.actions = fields.actions == null ? [] : fields.actions;
		this.allowLiveEventSource = fields.allowLiveEventSource;
	}

	public function enabled():Bool {
		return !allowLiveEventSource && actions.length > 0;
	}
}
