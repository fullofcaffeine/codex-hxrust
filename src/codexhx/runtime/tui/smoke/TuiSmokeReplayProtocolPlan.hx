package codexhx.runtime.tui.smoke;

typedef TuiSmokeReplayProtocolPlanFields = {
	final allowLiveTerminal:Bool;
	final allowAppServerMutation:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeReplayProtocolAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeReplayProtocolPlan {
	public final allowLiveTerminal:Bool;
	public final allowAppServerMutation:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeReplayProtocolAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
