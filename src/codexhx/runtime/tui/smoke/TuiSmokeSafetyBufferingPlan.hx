package codexhx.runtime.tui.smoke;

typedef TuiSmokeSafetyBufferingPlanFields = {
	final allowAppServerDelivery:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeSafetyBufferingAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Headless-only plan for model safety-buffering notification parity smoke events. */
class TuiSmokeSafetyBufferingPlan {
	public final allowAppServerDelivery:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeSafetyBufferingAction>;

	public function enabled():Bool {
		return !allowAppServerDelivery && !allowRatatuiRender && !allowModelCall && actions != null && actions.length > 0;
	}
}
