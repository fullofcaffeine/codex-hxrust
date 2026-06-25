package codexhx.runtime.tui.smoke;

typedef TuiSmokeAgentNavigationPlanFields = {
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokeAgentNavigationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAgentNavigationPlan {
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokeAgentNavigationAction>;

	public function enabled():Bool {
		return !allowModelCall && !allowAppServerMutation && !allowFilesystemMutation && actions != null && actions.length > 0;
	}
}
