package codexhx.runtime.tui.smoke;

typedef TuiSmokeSessionArchiveCommandPlanFields = {
	final allowLiveTerminal:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokeSessionArchiveCommandAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSessionArchiveCommandPlan {
	public final allowLiveTerminal:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokeSessionArchiveCommandAction>;

	public function enabled():Bool {
		return actions != null && actions.length > 0;
	}
}
