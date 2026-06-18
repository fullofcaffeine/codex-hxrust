package codexhx.runtime.tui.smoke;

typedef TuiSmokeOverlayRoutingPlanFields = {
	final allowLiveOverlay:Bool;
	final actions:Array<TuiSmokeOverlayRoutingAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeOverlayRoutingPlan {
	public final allowLiveOverlay:Bool;
	public final actions:Array<TuiSmokeOverlayRoutingAction>;

	public function enabled():Bool {
		return !allowLiveOverlay && actions.length > 0;
	}
}
