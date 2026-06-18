package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalModePlanFields = {
	final allowLiveTerminalMode:Bool;
	final actions:Array<TuiSmokeTerminalModeAction>;
}

class TuiSmokeTerminalModePlan {
	public final allowLiveTerminalMode:Bool;
	public final actions:Array<TuiSmokeTerminalModeAction>;

	public function new(fields:TuiSmokeTerminalModePlanFields) {
		this.allowLiveTerminalMode = fields.allowLiveTerminalMode;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveTerminalMode && actions.length > 0;
	}
}
