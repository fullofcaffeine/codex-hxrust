package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerErrorPlanFields = {
	final allowAppServerDelivery:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeAppServerErrorAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Headless-only plan for app-server error handling parity smoke events. */
class TuiSmokeAppServerErrorPlan {
	public final allowAppServerDelivery:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeAppServerErrorAction>;

	public function enabled():Bool {
		return !allowAppServerDelivery && !allowRatatuiRender && !allowModelCall && actions != null && actions.length > 0;
	}
}
