package codexhx.runtime.model.streamitem;

class ModelPendingInteractiveReplayRequest {
	public final requestId:String;
	public final reconstructionOutcome:ModelTurnReplayReconstructionOutcome;
	public final eventKind:ModelPendingInteractiveReplayEventKind;
	public final promptKind:ModelPendingInteractivePromptKind;
	public final turnId:String;
	public final activeTurnIdBefore:String;
	public final restoredInProgressTurnId:String;
	public final pendingPromptCountBefore:Int;
	public final pendingPromptCountForTurnBefore:Int;
	public final requestMatchesPendingPrompt:Bool;
	public final outboundOpCanChangeState:Bool;
	public final outboundOpMatchesPrompt:Bool;
	public final terminalMatchesActiveTurn:Bool;
	public final snapshotRequested:Bool;
	public final secretProbe:String;

	public function new(requestId:String, reconstructionOutcome:ModelTurnReplayReconstructionOutcome, eventKind:ModelPendingInteractiveReplayEventKind,
			promptKind:ModelPendingInteractivePromptKind, turnId:String, activeTurnIdBefore:String, restoredInProgressTurnId:String,
			pendingPromptCountBefore:Int, pendingPromptCountForTurnBefore:Int, requestMatchesPendingPrompt:Bool, outboundOpCanChangeState:Bool,
			outboundOpMatchesPrompt:Bool, terminalMatchesActiveTurn:Bool, snapshotRequested:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.reconstructionOutcome = reconstructionOutcome;
		this.eventKind = eventKind == null ? ModelPendingInteractiveReplayEventKind.Snapshot : eventKind;
		this.promptKind = promptKind == null ? ModelPendingInteractivePromptKind.None : promptKind;
		this.turnId = turnId == null ? "" : turnId;
		this.activeTurnIdBefore = activeTurnIdBefore == null ? "" : activeTurnIdBefore;
		this.restoredInProgressTurnId = restoredInProgressTurnId == null ? "" : restoredInProgressTurnId;
		this.pendingPromptCountBefore = pendingPromptCountBefore < 0 ? 0 : pendingPromptCountBefore;
		this.pendingPromptCountForTurnBefore = pendingPromptCountForTurnBefore < 0 ? 0 : pendingPromptCountForTurnBefore;
		this.requestMatchesPendingPrompt = requestMatchesPendingPrompt;
		this.outboundOpCanChangeState = outboundOpCanChangeState;
		this.outboundOpMatchesPrompt = outboundOpMatchesPrompt;
		this.terminalMatchesActiveTurn = terminalMatchesActiveTurn;
		this.snapshotRequested = snapshotRequested;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
