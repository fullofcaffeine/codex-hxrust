package codexhx.runtime.tui.smoke;

typedef TuiSmokeFileMentionPopupPlanFields = {
	final allowLiveFileSearch:Bool;
	final actions:Array<TuiSmokeFileMentionPopupAction>;
}

class TuiSmokeFileMentionPopupPlan {
	public final allowLiveFileSearch:Bool;
	public final actions:Array<TuiSmokeFileMentionPopupAction>;

	public function new(fields:TuiSmokeFileMentionPopupPlanFields) {
		this.allowLiveFileSearch = fields.allowLiveFileSearch;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveFileSearch && actions.length > 0;
	}
}
