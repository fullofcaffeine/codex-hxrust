package codexhx.runtime.tui.smoke;

typedef TuiSmokeClipboardPastePlanFields = {
	final allowLiveClipboard:Bool;
	final allowProcessSpawn:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokeClipboardPasteAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeClipboardPastePlan {
	public final allowLiveClipboard:Bool;
	public final allowProcessSpawn:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokeClipboardPasteAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
