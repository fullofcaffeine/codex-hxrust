package codexhx.runtime.tui.smoke;

typedef TuiSmokeApprovalPlanFields = {
	final allowLiveApproval:Bool;
	final actions:Array<TuiSmokeApprovalAction>;
}

class TuiSmokeApprovalPlan {
	public final allowLiveApproval:Bool;
	public final actions:Array<TuiSmokeApprovalAction>;

	public function new(fields:TuiSmokeApprovalPlanFields) {
		this.allowLiveApproval = fields.allowLiveApproval;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveApproval && actions.length > 0;
	}
}
