package codexhx.runtime.tui.smoke;

typedef TuiSmokeGoalMenuPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeGoalMenuAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGoalMenuPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeGoalMenuAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
