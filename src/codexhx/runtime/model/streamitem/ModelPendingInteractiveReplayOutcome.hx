package codexhx.runtime.model.streamitem;

class ModelPendingInteractiveReplayOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final reconstructionRequestId:String;
	public final eventKind:ModelPendingInteractiveReplayEventKind;
	public final promptKind:ModelPendingInteractivePromptKind;
	public final restoredActiveTurnDetected:Bool;
	public final activeTurnIdAfter:String;
	public final activeTurnCleared:Bool;
	public final nonmatchingCompletionPreservedActive:Bool;
	public final promptRecorded:Bool;
	public final promptRemovedByTurnCompletion:Bool;
	public final promptRemovedByOutboundOp:Bool;
	public final promptRemovedByResolution:Bool;
	public final promptRemovedByEviction:Bool;
	public final pendingReplayCleared:Bool;
	public final snapshotRequestReplayed:Bool;
	public final snapshotRequestFiltered:Bool;
	public final replayedTurnCompletedHandled:Bool;
	public final replayUsesThreadSnapshotKind:Bool;
	public final sideStatusKind:ModelPendingInteractiveSideStatusKind;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, reconstructionRequestId:String, eventKind:ModelPendingInteractiveReplayEventKind,
			promptKind:ModelPendingInteractivePromptKind, restoredActiveTurnDetected:Bool, activeTurnIdAfter:String, activeTurnCleared:Bool,
			nonmatchingCompletionPreservedActive:Bool, promptRecorded:Bool, promptRemovedByTurnCompletion:Bool, promptRemovedByOutboundOp:Bool,
			promptRemovedByResolution:Bool, promptRemovedByEviction:Bool, pendingReplayCleared:Bool, snapshotRequestReplayed:Bool,
			snapshotRequestFiltered:Bool, replayedTurnCompletedHandled:Bool, replayUsesThreadSnapshotKind:Bool,
			sideStatusKind:ModelPendingInteractiveSideStatusKind, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool,
			errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.reconstructionRequestId = reconstructionRequestId == null ? "" : reconstructionRequestId;
		this.eventKind = eventKind == null ? ModelPendingInteractiveReplayEventKind.Snapshot : eventKind;
		this.promptKind = promptKind == null ? ModelPendingInteractivePromptKind.None : promptKind;
		this.restoredActiveTurnDetected = restoredActiveTurnDetected;
		this.activeTurnIdAfter = activeTurnIdAfter == null ? "" : activeTurnIdAfter;
		this.activeTurnCleared = activeTurnCleared;
		this.nonmatchingCompletionPreservedActive = nonmatchingCompletionPreservedActive;
		this.promptRecorded = promptRecorded;
		this.promptRemovedByTurnCompletion = promptRemovedByTurnCompletion;
		this.promptRemovedByOutboundOp = promptRemovedByOutboundOp;
		this.promptRemovedByResolution = promptRemovedByResolution;
		this.promptRemovedByEviction = promptRemovedByEviction;
		this.pendingReplayCleared = pendingReplayCleared;
		this.snapshotRequestReplayed = snapshotRequestReplayed;
		this.snapshotRequestFiltered = snapshotRequestFiltered;
		this.replayedTurnCompletedHandled = replayedTurnCompletedHandled;
		this.replayUsesThreadSnapshotKind = replayUsesThreadSnapshotKind;
		this.sideStatusKind = sideStatusKind == null ? ModelPendingInteractiveSideStatusKind.None : sideStatusKind;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";reconstructionRequest=" + noneIfEmpty(reconstructionRequestId)
			+ ";eventKind=" + eventKind + ";promptKind=" + promptKind + ";restoredActiveTurnDetected=" + boolText(restoredActiveTurnDetected)
			+ ";activeTurnIdAfter=" + noneIfEmpty(activeTurnIdAfter) + ";activeTurnCleared=" + boolText(activeTurnCleared)
			+ ";nonmatchingCompletionPreservedActive=" + boolText(nonmatchingCompletionPreservedActive) + ";promptRecorded=" + boolText(promptRecorded)
			+ ";promptRemovedByTurnCompletion=" + boolText(promptRemovedByTurnCompletion) + ";promptRemovedByOutboundOp="
			+ boolText(promptRemovedByOutboundOp) + ";promptRemovedByResolution=" + boolText(promptRemovedByResolution) + ";promptRemovedByEviction="
			+ boolText(promptRemovedByEviction) + ";pendingReplayCleared=" + boolText(pendingReplayCleared) + ";snapshotRequestReplayed="
			+ boolText(snapshotRequestReplayed) + ";snapshotRequestFiltered=" + boolText(snapshotRequestFiltered) + ";replayedTurnCompletedHandled="
			+ boolText(replayedTurnCompletedHandled) + ";replayUsesThreadSnapshotKind=" + boolText(replayUsesThreadSnapshotKind) + ";sideStatusKind="
			+ sideStatusKind + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
