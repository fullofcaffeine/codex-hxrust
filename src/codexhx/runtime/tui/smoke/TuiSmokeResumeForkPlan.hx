package codexhx.runtime.tui.smoke;

typedef TuiSmokeResumeForkPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokeResumeForkAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeResumeForkPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokeResumeForkAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && !allowFilesystemMutation && actions.length > 0;
	}
}
