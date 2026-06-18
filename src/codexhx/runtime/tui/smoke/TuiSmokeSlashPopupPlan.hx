package codexhx.runtime.tui.smoke;

typedef TuiSmokeSlashPopupPlanFields = {
	final allowLiveInput:Bool;
	final actions:Array<TuiSmokeSlashPopupAction>;
}

class TuiSmokeSlashPopupPlan {
	public final allowLiveInput:Bool;
	public final actions:Array<TuiSmokeSlashPopupAction>;

	public function new(fields:TuiSmokeSlashPopupPlanFields) {
		this.allowLiveInput = fields.allowLiveInput;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveInput && actions.length > 0;
	}
}
