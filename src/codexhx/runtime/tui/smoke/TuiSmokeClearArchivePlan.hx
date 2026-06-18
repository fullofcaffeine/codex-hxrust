package codexhx.runtime.tui.smoke;

typedef TuiSmokeClearArchivePlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeClearArchiveAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeClearArchivePlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeClearArchiveAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && !allowModelCall && actions.length > 0;
	}
}
