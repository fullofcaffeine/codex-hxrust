package codexhx.runtime.model.streamitem;

class ModelTurnReplayReconstructionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final projectionRequestId:String;
	public final replayKind:ModelTurnReplayKind;
	public final targetKind:ModelTurnReplayTargetKind;
	public final terminalTurnId:String;
	public final reconstructedStatusKind:ModelTurnTerminalProjectedStatusKind;
	public final currentTurnClosed:Bool;
	public final currentTurnMarkedTerminal:Bool;
	public final historicalTurnUpdated:Bool;
	public final activeTurnPreserved:Bool;
	public final fallbackAppliedToActive:Bool;
	public final missingTerminalNoop:Bool;
	public final failedStatusPreserved:Bool;
	public final replayTurnCompletedNotificationSynthesized:Bool;
	public final tuiReplayKindAttached:Bool;
	public final tuiTaskStartedForInProgress:Bool;
	public final resumeInitialStartSuppressed:Bool;
	public final liveOnlyReplayEffectsSuppressed:Bool;
	public final lastAgentMessageRemainsProjectionOnly:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, projectionRequestId:String, replayKind:ModelTurnReplayKind,
			targetKind:ModelTurnReplayTargetKind, terminalTurnId:String, reconstructedStatusKind:ModelTurnTerminalProjectedStatusKind, currentTurnClosed:Bool,
			currentTurnMarkedTerminal:Bool, historicalTurnUpdated:Bool, activeTurnPreserved:Bool, fallbackAppliedToActive:Bool, missingTerminalNoop:Bool,
			failedStatusPreserved:Bool, replayTurnCompletedNotificationSynthesized:Bool, tuiReplayKindAttached:Bool, tuiTaskStartedForInProgress:Bool,
			resumeInitialStartSuppressed:Bool, liveOnlyReplayEffectsSuppressed:Bool, lastAgentMessageRemainsProjectionOnly:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.projectionRequestId = projectionRequestId == null ? "" : projectionRequestId;
		this.replayKind = replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : replayKind;
		this.targetKind = targetKind == null ? ModelTurnReplayTargetKind.ActiveExact : targetKind;
		this.terminalTurnId = terminalTurnId == null ? "" : terminalTurnId;
		this.reconstructedStatusKind = reconstructedStatusKind == null ? ModelTurnTerminalProjectedStatusKind.Completed : reconstructedStatusKind;
		this.currentTurnClosed = currentTurnClosed;
		this.currentTurnMarkedTerminal = currentTurnMarkedTerminal;
		this.historicalTurnUpdated = historicalTurnUpdated;
		this.activeTurnPreserved = activeTurnPreserved;
		this.fallbackAppliedToActive = fallbackAppliedToActive;
		this.missingTerminalNoop = missingTerminalNoop;
		this.failedStatusPreserved = failedStatusPreserved;
		this.replayTurnCompletedNotificationSynthesized = replayTurnCompletedNotificationSynthesized;
		this.tuiReplayKindAttached = tuiReplayKindAttached;
		this.tuiTaskStartedForInProgress = tuiTaskStartedForInProgress;
		this.resumeInitialStartSuppressed = resumeInitialStartSuppressed;
		this.liveOnlyReplayEffectsSuppressed = liveOnlyReplayEffectsSuppressed;
		this.lastAgentMessageRemainsProjectionOnly = lastAgentMessageRemainsProjectionOnly;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";projectionRequest=" + noneIfEmpty(projectionRequestId) + ";replayKind="
			+ replayKind + ";targetKind=" + targetKind + ";terminalTurn=" + noneIfEmpty(terminalTurnId) + ";reconstructedStatusKind="
			+ reconstructedStatusKind + ";currentTurnClosed=" + boolText(currentTurnClosed) + ";currentTurnMarkedTerminal="
			+ boolText(currentTurnMarkedTerminal) + ";historicalTurnUpdated=" + boolText(historicalTurnUpdated) + ";activeTurnPreserved="
			+ boolText(activeTurnPreserved) + ";fallbackAppliedToActive=" + boolText(fallbackAppliedToActive) + ";missingTerminalNoop="
			+ boolText(missingTerminalNoop) + ";failedStatusPreserved=" + boolText(failedStatusPreserved) + ";replayTurnCompletedNotificationSynthesized="
			+ boolText(replayTurnCompletedNotificationSynthesized) + ";tuiReplayKindAttached=" + boolText(tuiReplayKindAttached)
			+ ";tuiTaskStartedForInProgress=" + boolText(tuiTaskStartedForInProgress) + ";resumeInitialStartSuppressed="
			+ boolText(resumeInitialStartSuppressed) + ";liveOnlyReplayEffectsSuppressed=" + boolText(liveOnlyReplayEffectsSuppressed)
			+ ";lastAgentMessageRemainsProjectionOnly=" + boolText(lastAgentMessageRemainsProjectionOnly) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
