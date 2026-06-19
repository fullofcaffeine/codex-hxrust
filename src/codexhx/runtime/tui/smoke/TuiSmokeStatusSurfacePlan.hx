package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusSurfacePlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeStatusSurfaceAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusSurfacePlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeStatusSurfaceAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
