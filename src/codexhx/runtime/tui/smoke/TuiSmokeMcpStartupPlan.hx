package codexhx.runtime.tui.smoke;

typedef TuiSmokeMcpStartupPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeMcpStartupAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMcpStartupPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeMcpStartupAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
