package codexhx.runtime.tui.smoke;

typedef TuiSmokeUserInputPlanFields = {
	final allowLiveUserInput:Bool;
	final actions:Array<TuiSmokeUserInputAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeUserInputPlan {
	public final allowLiveUserInput:Bool;
	public final actions:Array<TuiSmokeUserInputAction>;

	public function enabled():Bool {
		return !allowLiveUserInput && actions.length > 0;
	}
}
