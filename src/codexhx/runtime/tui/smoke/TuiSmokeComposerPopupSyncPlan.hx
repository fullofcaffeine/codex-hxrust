package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupSyncPlanFields = {
	final allowLiveFileSearch:Bool;
	final actions:Array<TuiSmokeComposerPopupSyncAction>;
}

class TuiSmokeComposerPopupSyncPlan {
	public final allowLiveFileSearch:Bool;
	public final actions:Array<TuiSmokeComposerPopupSyncAction>;

	public function new(fields:TuiSmokeComposerPopupSyncPlanFields) {
		this.allowLiveFileSearch = fields.allowLiveFileSearch;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveFileSearch && actions.length > 0;
	}
}
