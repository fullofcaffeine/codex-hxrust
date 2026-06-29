package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerTurnStatePlanFields = {
	final allowAppServerDelivery:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeAppServerTurnStateAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Headless-only plan for upstream ChatWidget app-server turn-state parity smoke events. */
class TuiSmokeAppServerTurnStatePlan {
	public final allowAppServerDelivery:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeAppServerTurnStateAction>;

	public function enabled():Bool {
		return !allowAppServerDelivery && !allowRatatuiRender && !allowModelCall && actions != null && actions.length > 0;
	}
}
