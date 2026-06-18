package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadReplayActionFields = {
	final kind:TuiSmokeThreadReplayActionKind;
	final threadId:String;
	final session:Null<TuiSmokeThreadSession>;
	final inputState:Null<TuiSmokeThreadInputState>;
	final turns:Array<TuiSmokeThreadTurn>;
	final snapshotRequests:Array<TuiSmokeAppServerRequest>;
	final snapshotEvents:Array<TuiSmokeThreadReplayEvent>;
	final traceRequestSurfaces:Bool;
	final resizeReflowEnabled:Bool;
	final resumeRestoredQueue:Bool;
}

class TuiSmokeThreadReplayAction {
	public final kind:TuiSmokeThreadReplayActionKind;
	public final threadId:String;
	public final session:Null<TuiSmokeThreadSession>;
	public final inputState:Null<TuiSmokeThreadInputState>;
	public final turns:Array<TuiSmokeThreadTurn>;
	public final snapshotRequests:Array<TuiSmokeAppServerRequest>;
	public final snapshotEvents:Array<TuiSmokeThreadReplayEvent>;
	public final traceRequestSurfaces:Bool;
	public final resizeReflowEnabled:Bool;
	public final resumeRestoredQueue:Bool;

	public function new(fields:TuiSmokeThreadReplayActionFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadReplayActionKind.Unknown : fields.kind;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.session = fields.session;
		this.inputState = fields.inputState;
		this.turns = fields.turns == null ? [] : fields.turns;
		this.snapshotRequests = fields.snapshotRequests == null ? [] : fields.snapshotRequests;
		this.snapshotEvents = fields.snapshotEvents == null ? [] : fields.snapshotEvents;
		this.traceRequestSurfaces = fields.traceRequestSurfaces;
		this.resizeReflowEnabled = fields.resizeReflowEnabled;
		this.resumeRestoredQueue = fields.resumeRestoredQueue;
	}

	public function shouldBufferReplay(hasSnapshotEvents:Bool):Bool {
		return resizeReflowEnabled && (turns.length > 0 || snapshotRequests.length > 0 || snapshotEvents.length > 0 || hasSnapshotEvents);
	}
}
