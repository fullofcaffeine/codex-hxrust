package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadReplayActionFields = {
	final kind:TuiSmokeThreadReplayActionKind;
	final threadId:String;
	final session:Null<TuiSmokeThreadSession>;
	final inputState:Null<TuiSmokeThreadInputState>;
	final turns:Array<TuiSmokeThreadTurn>;
	final snapshotRequests:Array<TuiSmokeAppServerRequest>;
	final snapshotEvents:Array<TuiSmokeThreadReplayEvent>;
	final replayBuffer:Null<TuiSmokeReplayBufferPlan>;
	final traceRequestSurfaces:Bool;
	final resizeReflowEnabled:Bool;
	final resumeRestoredQueue:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadReplayAction {
	public final kind:TuiSmokeThreadReplayActionKind;
	public final threadId:String;
	public final session:Null<TuiSmokeThreadSession>;
	public final inputState:Null<TuiSmokeThreadInputState>;
	public final turns:Array<TuiSmokeThreadTurn>;
	public final snapshotRequests:Array<TuiSmokeAppServerRequest>;
	public final snapshotEvents:Array<TuiSmokeThreadReplayEvent>;
	public final replayBuffer:Null<TuiSmokeReplayBufferPlan>;
	public final traceRequestSurfaces:Bool;
	public final resizeReflowEnabled:Bool;
	public final resumeRestoredQueue:Bool;

	public function shouldBufferReplay(hasSnapshotEvents:Bool):Bool {
		final hasReplayBuffer = replayBuffer != null && replayBuffer.enabled();
		return (resizeReflowEnabled || hasReplayBuffer)
			&& (turns.length > 0 || snapshotRequests.length > 0 || snapshotEvents.length > 0 || hasSnapshotEvents || hasReplayBuffer);
	}
}
