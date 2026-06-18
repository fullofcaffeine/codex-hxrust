package codexhx.runtime.tui.smoke;

typedef TuiSmokeOverlayRoutingPlanFields = {
	final allowLiveOverlay:Bool;
	final actions:Array<TuiSmokeOverlayRoutingAction>;
}

class TuiSmokeOverlayRoutingPlan {
	public final allowLiveOverlay:Bool;
	public final actions:Array<TuiSmokeOverlayRoutingAction>;

	public function new(fields:TuiSmokeOverlayRoutingPlanFields) {
		this.allowLiveOverlay = fields.allowLiveOverlay;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveOverlay && actions.length > 0;
	}
}
