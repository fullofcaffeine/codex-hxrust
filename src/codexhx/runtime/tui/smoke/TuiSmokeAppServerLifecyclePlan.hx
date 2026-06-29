package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerLifecyclePlanFields = {
	final allowAppServerDelivery:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeAppServerLifecycleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Headless-only plan for app-server lifecycle notification parity smoke events. */
class TuiSmokeAppServerLifecyclePlan {
	public final allowAppServerDelivery:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeAppServerLifecycleAction>;

	public function enabled():Bool {
		return !allowAppServerDelivery && !allowRatatuiRender && !allowModelCall && actions != null && actions.length > 0;
	}
}
