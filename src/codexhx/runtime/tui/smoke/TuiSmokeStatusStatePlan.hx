package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusStatePlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeStatusStateAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusStatePlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeStatusStateAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
