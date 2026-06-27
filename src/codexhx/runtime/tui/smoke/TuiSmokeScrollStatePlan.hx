package codexhx.runtime.tui.smoke;

typedef TuiSmokeScrollStatePlanFields = {
	final allowTerminalMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeScrollStateAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeScrollStatePlan {
	public final allowTerminalMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeScrollStateAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
