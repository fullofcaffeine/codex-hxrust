package codexhx.runtime.tui.smoke;

typedef TuiSmokeMcpElicitationPlanFields = {
	final allowLiveElicitation:Bool;
	final actions:Array<TuiSmokeMcpElicitationAction>;
}

class TuiSmokeMcpElicitationPlan {
	public final allowLiveElicitation:Bool;
	public final actions:Array<TuiSmokeMcpElicitationAction>;

	public function new(fields:TuiSmokeMcpElicitationPlanFields) {
		this.allowLiveElicitation = fields.allowLiveElicitation;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveElicitation && actions.length > 0;
	}
}
