package codexhx.runtime.tui.smoke;

typedef TuiSmokeAltScreenPlanFields = {
	final allowLiveAltScreen:Bool;
	final actions:Array<TuiSmokeAltScreenAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAltScreenPlan {
	public final allowLiveAltScreen:Bool;
	public final actions:Array<TuiSmokeAltScreenAction>;

	public function enabled():Bool {
		return !allowLiveAltScreen && actions.length > 0;
	}
}
