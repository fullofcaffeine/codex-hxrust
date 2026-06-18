package codexhx.runtime.tui.smoke;

typedef TuiSmokeAltScreenPlanFields = {
	final allowLiveAltScreen:Bool;
	final actions:Array<TuiSmokeAltScreenAction>;
}

class TuiSmokeAltScreenPlan {
	public final allowLiveAltScreen:Bool;
	public final actions:Array<TuiSmokeAltScreenAction>;

	public function new(fields:TuiSmokeAltScreenPlanFields) {
		this.allowLiveAltScreen = fields.allowLiveAltScreen;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveAltScreen && actions.length > 0;
	}
}
