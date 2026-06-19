package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusSurfaceRenderPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeStatusSurfaceRenderAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusSurfaceRenderPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeStatusSurfaceRenderAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
