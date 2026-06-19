package codexhx.runtime.tui.smoke;

typedef TuiSmokeBacktrackOverlayPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeBacktrackOverlayAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeBacktrackOverlayPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeBacktrackOverlayAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
