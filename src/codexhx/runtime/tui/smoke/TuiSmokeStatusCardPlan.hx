package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusCardPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeStatusCardAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusCardPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeStatusCardAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
