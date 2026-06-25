package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalVisualizationPlanFields = {
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeTerminalVisualizationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalVisualizationPlan {
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeTerminalVisualizationAction>;

	public function enabled():Bool {
		return !allowModelCall && !allowAppServerMutation && actions != null && actions.length > 0;
	}
}
