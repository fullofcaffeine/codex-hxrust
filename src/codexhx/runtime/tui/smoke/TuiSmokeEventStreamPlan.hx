package codexhx.runtime.tui.smoke;

typedef TuiSmokeEventStreamPlanFields = {
	final initialState:TuiSmokeEventStreamBrokerState;
	final actions:Array<TuiSmokeEventStreamAction>;
	final allowLiveEventSource:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeEventStreamPlan {
	public final initialState:TuiSmokeEventStreamBrokerState;
	public final actions:Array<TuiSmokeEventStreamAction>;
	public final allowLiveEventSource:Bool;

	public function enabled():Bool {
		return !allowLiveEventSource && actions.length > 0;
	}
}
