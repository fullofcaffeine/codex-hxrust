package codexhx.runtime.tui.smoke;

typedef TuiSmokeLineTruncationPlanFields = {
	final allowRatatuiRender:Bool;
	final allowTerminalMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeLineTruncationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLineTruncationPlan {
	public final allowRatatuiRender:Bool;
	public final allowTerminalMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeLineTruncationAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
