package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalTitlePlanFields = {
	final allowLiveTitleWrite:Bool;
	final actions:Array<TuiSmokeTerminalTitleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalTitlePlan {
	public final allowLiveTitleWrite:Bool;
	public final actions:Array<TuiSmokeTerminalTitleAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
