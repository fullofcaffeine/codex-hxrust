package codexhx.runtime.tui.smoke;

typedef TuiSmokeKeymapRawOutputPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeKeymapRawOutputAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeKeymapRawOutputPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeKeymapRawOutputAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
