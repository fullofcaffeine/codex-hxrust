package codexhx.runtime.tui.smoke;

typedef TuiSmokeSlashCommandPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeSlashCommandAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSlashCommandPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeSlashCommandAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
