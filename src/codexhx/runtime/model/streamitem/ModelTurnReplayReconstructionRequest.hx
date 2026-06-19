package codexhx.runtime.model.streamitem;

class ModelTurnReplayReconstructionRequest {
	public final requestId:String;
	public final projectionOutcome:ModelTurnTerminalProjectionOutcome;
	public final replayKind:ModelTurnReplayKind;
	public final targetKind:ModelTurnReplayTargetKind;
	public final activeTurnId:String;
	public final historicalTurnId:String;
	public final terminalTurnId:String;
	public final activeTurnPresent:Bool;
	public final turnWasInProgress:Bool;
	public final replayTurnHasItems:Bool;
	public final secretProbe:String;

	public function new(requestId:String, projectionOutcome:ModelTurnTerminalProjectionOutcome, replayKind:ModelTurnReplayKind,
			targetKind:ModelTurnReplayTargetKind, activeTurnId:String, historicalTurnId:String, terminalTurnId:String, activeTurnPresent:Bool,
			turnWasInProgress:Bool, replayTurnHasItems:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.projectionOutcome = projectionOutcome;
		this.replayKind = replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : replayKind;
		this.targetKind = targetKind == null ? ModelTurnReplayTargetKind.ActiveExact : targetKind;
		this.activeTurnId = activeTurnId == null ? "" : activeTurnId;
		this.historicalTurnId = historicalTurnId == null ? "" : historicalTurnId;
		this.terminalTurnId = terminalTurnId == null ? "" : terminalTurnId;
		this.activeTurnPresent = activeTurnPresent;
		this.turnWasInProgress = turnWasInProgress;
		this.replayTurnHasItems = replayTurnHasItems;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
