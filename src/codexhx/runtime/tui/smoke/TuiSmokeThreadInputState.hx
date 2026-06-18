package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadInputStateFields = {
	final composerText:String;
	final taskRunning:Bool;
	final queuedUserMessageCount:Int;
	final pendingInitialSubmit:Bool;
}

class TuiSmokeThreadInputState {
	public final composerText:String;
	public final taskRunning:Bool;
	public final queuedUserMessageCount:Int;
	public final pendingInitialSubmit:Bool;

	public function new(fields:TuiSmokeThreadInputStateFields) {
		this.composerText = fields.composerText == null ? "" : fields.composerText;
		this.taskRunning = fields.taskRunning;
		this.queuedUserMessageCount = fields.queuedUserMessageCount < 0 ? 0 : fields.queuedUserMessageCount;
		this.pendingInitialSubmit = fields.pendingInitialSubmit;
	}

	public function hasQueuedUserMessage():Bool {
		return queuedUserMessageCount > 0;
	}
}
