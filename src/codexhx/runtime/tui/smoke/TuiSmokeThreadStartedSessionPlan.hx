package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadStartedSessionPlanFields = {
	final allowAppServerMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeThreadStartedSessionAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadStartedSessionPlan {
	public final allowAppServerMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeThreadStartedSessionAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
