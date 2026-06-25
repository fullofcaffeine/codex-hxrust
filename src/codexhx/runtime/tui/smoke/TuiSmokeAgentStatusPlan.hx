package codexhx.runtime.tui.smoke;

typedef TuiSmokeAgentStatusPlanFields = {
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokeAgentStatusAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAgentStatusPlan {
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokeAgentStatusAction>;

	public function enabled():Bool {
		return !allowModelCall && !allowAppServerMutation && !allowFilesystemMutation && actions != null && actions.length > 0;
	}
}
