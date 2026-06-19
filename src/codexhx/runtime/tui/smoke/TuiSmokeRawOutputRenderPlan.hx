package codexhx.runtime.tui.smoke;

typedef TuiSmokeRawOutputRenderPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeRawOutputRenderAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeRawOutputRenderPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeRawOutputRenderAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
