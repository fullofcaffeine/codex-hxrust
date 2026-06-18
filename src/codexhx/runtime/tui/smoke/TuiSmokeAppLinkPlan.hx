package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppLinkPlanFields = {
	final allowLiveBrowser:Bool;
	final actions:Array<TuiSmokeAppLinkAction>;
}

class TuiSmokeAppLinkPlan {
	public final allowLiveBrowser:Bool;
	public final actions:Array<TuiSmokeAppLinkAction>;

	public function new(fields:TuiSmokeAppLinkPlanFields) {
		this.allowLiveBrowser = fields.allowLiveBrowser;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveBrowser && actions.length > 0;
	}
}
