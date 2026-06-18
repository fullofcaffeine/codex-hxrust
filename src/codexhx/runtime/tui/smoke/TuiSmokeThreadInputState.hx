package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadInputStateFields = {
	final composerText:String;
	final taskRunning:Bool;
	final queuedUserMessageCount:Int;
	final pendingInitialSubmit:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadInputState {
	public final composerText:String;
	public final taskRunning:Bool;
	@:recordMin(0)
	public final queuedUserMessageCount:Int;
	public final pendingInitialSubmit:Bool;

	public function hasQueuedUserMessage():Bool {
		return queuedUserMessageCount > 0;
	}
}
