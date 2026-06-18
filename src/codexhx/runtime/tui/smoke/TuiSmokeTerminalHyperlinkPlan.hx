package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalHyperlinkPlanFields = {
	final allowLiveTerminal:Bool;
	final actions:Array<TuiSmokeTerminalHyperlinkAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalHyperlinkPlan {
	public final allowLiveTerminal:Bool;
	public final actions:Array<TuiSmokeTerminalHyperlinkAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
