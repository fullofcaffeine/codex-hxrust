package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalModePlanFields = {
	final allowLiveTerminalMode:Bool;
	final actions:Array<TuiSmokeTerminalModeAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalModePlan {
	public final allowLiveTerminalMode:Bool;
	public final actions:Array<TuiSmokeTerminalModeAction>;

	public function enabled():Bool {
		return !allowLiveTerminalMode && actions.length > 0;
	}
}
