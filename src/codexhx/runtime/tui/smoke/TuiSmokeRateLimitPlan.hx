package codexhx.runtime.tui.smoke;

typedef TuiSmokeRateLimitPlanFields = {
	final allowLiveAccountRefresh:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeRateLimitAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeRateLimitPlan {
	public final allowLiveAccountRefresh:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeRateLimitAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
