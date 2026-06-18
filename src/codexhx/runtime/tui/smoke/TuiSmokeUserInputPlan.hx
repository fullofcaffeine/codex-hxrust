package codexhx.runtime.tui.smoke;

typedef TuiSmokeUserInputPlanFields = {
	final allowLiveUserInput:Bool;
	final actions:Array<TuiSmokeUserInputAction>;
}

class TuiSmokeUserInputPlan {
	public final allowLiveUserInput:Bool;
	public final actions:Array<TuiSmokeUserInputAction>;

	public function new(fields:TuiSmokeUserInputPlanFields) {
		this.allowLiveUserInput = fields.allowLiveUserInput;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveUserInput && actions.length > 0;
	}
}
