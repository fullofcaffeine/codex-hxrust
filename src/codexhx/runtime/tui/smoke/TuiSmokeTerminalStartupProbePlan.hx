package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalStartupProbePlanFields = {
	final allowLiveProbe:Bool;
	final actions:Array<TuiSmokeTerminalStartupProbeAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalStartupProbePlan {
	public final allowLiveProbe:Bool;
	public final actions:Array<TuiSmokeTerminalStartupProbeAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
