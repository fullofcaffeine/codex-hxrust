package codexhx.runtime.tui.smoke;

typedef TuiSmokeClipboardCopyPlanFields = {
	final allowLiveClipboard:Bool;
	final allowLiveTerminalWrite:Bool;
	final allowProcessSpawn:Bool;
	final actions:Array<TuiSmokeClipboardCopyAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeClipboardCopyPlan {
	public final allowLiveClipboard:Bool;
	public final allowLiveTerminalWrite:Bool;
	public final allowProcessSpawn:Bool;
	public final actions:Array<TuiSmokeClipboardCopyAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
