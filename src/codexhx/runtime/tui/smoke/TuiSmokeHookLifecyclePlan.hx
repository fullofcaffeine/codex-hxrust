package codexhx.runtime.tui.smoke;

typedef TuiSmokeHookLifecyclePlanFields = {
	final allowLiveHookExecution:Bool;
	final allowFilesystemMutation:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeHookLifecycleAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeHookLifecyclePlan {
	public final allowLiveHookExecution:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeHookLifecycleAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
