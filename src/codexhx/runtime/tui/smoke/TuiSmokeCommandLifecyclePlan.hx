package codexhx.runtime.tui.smoke;

typedef TuiSmokeCommandLifecyclePlanFields = {
	final allowLiveTerminal:Bool;
	final allowProcessSpawn:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeCommandLifecycleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCommandLifecyclePlan {
	public final allowLiveTerminal:Bool;
	public final allowProcessSpawn:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeCommandLifecycleAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
