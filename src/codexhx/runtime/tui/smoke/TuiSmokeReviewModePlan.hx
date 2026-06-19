package codexhx.runtime.tui.smoke;

typedef TuiSmokeReviewModePlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeReviewModeAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeReviewModePlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeReviewModeAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
