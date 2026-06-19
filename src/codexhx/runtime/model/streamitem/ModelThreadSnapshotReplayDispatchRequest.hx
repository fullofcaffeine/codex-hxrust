package codexhx.runtime.model.streamitem;

class ModelThreadSnapshotReplayDispatchRequest {
	public final requestId:String;
	public final pendingReplayOutcome:ModelPendingInteractiveReplayOutcome;
	public final replayKind:ModelTurnReplayKind;
	public final eventKind:ModelThreadSnapshotReplayEventKind;
	public final turnCount:Int;
	public final bufferedEventCount:Int;
	public final terminalResizeReflowEnabled:Bool;
	public final inputStateAvailable:Bool;
	public final suppressReplayNotices:Bool;
	public final eventIsNotice:Bool;
	public final snapshotRequestAllowed:Bool;
	public final pendingPrimaryEventCount:Int;
	public final secretProbe:String;

	public function new(requestId:String, pendingReplayOutcome:ModelPendingInteractiveReplayOutcome, replayKind:ModelTurnReplayKind,
			eventKind:ModelThreadSnapshotReplayEventKind, turnCount:Int, bufferedEventCount:Int, terminalResizeReflowEnabled:Bool, inputStateAvailable:Bool,
			suppressReplayNotices:Bool, eventIsNotice:Bool, snapshotRequestAllowed:Bool, pendingPrimaryEventCount:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.pendingReplayOutcome = pendingReplayOutcome;
		this.replayKind = replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : replayKind;
		this.eventKind = eventKind == null ? ModelThreadSnapshotReplayEventKind.ReplayTurns : eventKind;
		this.turnCount = turnCount < 0 ? 0 : turnCount;
		this.bufferedEventCount = bufferedEventCount < 0 ? 0 : bufferedEventCount;
		this.terminalResizeReflowEnabled = terminalResizeReflowEnabled;
		this.inputStateAvailable = inputStateAvailable;
		this.suppressReplayNotices = suppressReplayNotices;
		this.eventIsNotice = eventIsNotice;
		this.snapshotRequestAllowed = snapshotRequestAllowed;
		this.pendingPrimaryEventCount = pendingPrimaryEventCount < 0 ? 0 : pendingPrimaryEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
