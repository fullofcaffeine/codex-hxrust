package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetInterruptedRestorePlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeChatWidgetInterruptedRestoreAction>;
}

class TuiSmokeChatWidgetInterruptedRestorePlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeChatWidgetInterruptedRestoreAction>;

	public function new(fields:TuiSmokeChatWidgetInterruptedRestorePlanFields) {
		this.allowLiveTerminal = fields.allowLiveTerminal;
		this.allowRatatuiRender = fields.allowRatatuiRender;
		this.allowModelCall = fields.allowModelCall;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
