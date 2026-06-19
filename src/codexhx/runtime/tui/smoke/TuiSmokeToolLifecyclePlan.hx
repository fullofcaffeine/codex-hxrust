package codexhx.runtime.tui.smoke;

typedef TuiSmokeToolLifecyclePlanFields = {
	final allowLiveToolExecution:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeToolLifecycleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeToolLifecyclePlan {
	public final allowLiveToolExecution:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeToolLifecycleAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
