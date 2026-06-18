package codexhx.runtime.tui.smoke;

typedef TuiSmokeHooksBrowserPlanFields = {
	final allowLiveHooks:Bool;
	final actions:Array<TuiSmokeHooksBrowserAction>;
}

class TuiSmokeHooksBrowserPlan {
	public final allowLiveHooks:Bool;
	public final actions:Array<TuiSmokeHooksBrowserAction>;

	public function new(fields:TuiSmokeHooksBrowserPlanFields) {
		this.allowLiveHooks = fields.allowLiveHooks;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveHooks && actions.length > 0;
	}
}
