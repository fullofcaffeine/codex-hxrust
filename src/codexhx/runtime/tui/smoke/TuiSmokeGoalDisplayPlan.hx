package codexhx.runtime.tui.smoke;

typedef TuiSmokeGoalDisplayPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeGoalDisplayAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGoalDisplayPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeGoalDisplayAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
