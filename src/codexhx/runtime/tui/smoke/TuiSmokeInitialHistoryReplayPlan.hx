package codexhx.runtime.tui.smoke;

typedef TuiSmokeInitialHistoryReplayPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokeInitialHistoryReplayAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeInitialHistoryReplayPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokeInitialHistoryReplayAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && !allowFilesystemMutation && actions != null;
	}
}
