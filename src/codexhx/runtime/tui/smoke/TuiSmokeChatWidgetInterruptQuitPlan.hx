package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetInterruptQuitPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeChatWidgetInterruptQuitAction>;
}

class TuiSmokeChatWidgetInterruptQuitPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeChatWidgetInterruptQuitAction>;

	public function new(fields:TuiSmokeChatWidgetInterruptQuitPlanFields) {
		this.allowLiveTerminal = fields.allowLiveTerminal;
		this.allowRatatuiRender = fields.allowRatatuiRender;
		this.allowModelCall = fields.allowModelCall;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
