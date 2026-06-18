package codexhx.runtime.tui.smoke;

typedef TuiSmokeHistorySearchPlanFields = {
	final allowLiveHistoryLookup:Bool;
	final actions:Array<TuiSmokeHistorySearchAction>;
}

class TuiSmokeHistorySearchPlan {
	public final allowLiveHistoryLookup:Bool;
	public final actions:Array<TuiSmokeHistorySearchAction>;

	public function new(fields:TuiSmokeHistorySearchPlanFields) {
		this.allowLiveHistoryLookup = fields.allowLiveHistoryLookup;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveHistoryLookup && actions.length > 0;
	}
}
