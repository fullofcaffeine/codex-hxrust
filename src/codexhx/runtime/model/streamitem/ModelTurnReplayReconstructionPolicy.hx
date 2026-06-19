package codexhx.runtime.model.streamitem;

class ModelTurnReplayReconstructionPolicy {
	public static function reconstruct(request:ModelTurnReplayReconstructionRequest):ModelTurnReplayReconstructionOutcome {
		if (request == null)
			return failure("", "", ModelTurnReplayKind.ThreadSnapshot, ModelTurnReplayTargetKind.MissingNoop, "", "missing turn replay reconstruction request");
		if (request.projectionOutcome == null) {
			return failure(request.requestId, "", request.replayKind, request.targetKind, request.terminalTurnId, "missing terminal projection outcome");
		}
		if (!request.projectionOutcome.ok) {
			return failure(request.requestId, request.projectionOutcome.requestId, request.replayKind, request.targetKind, request.terminalTurnId,
				"terminal projection outcome was not successful");
		}

		final terminalTurnId = request.terminalTurnId.length > 0 ? request.terminalTurnId : request.projectionOutcome.turnId;
		final status = request.projectionOutcome.appTurnStatusKind;
		final completedTerminal = status == ModelTurnTerminalProjectedStatusKind.Completed
			|| status == ModelTurnTerminalProjectedStatusKind.Failed;
		final interruptedTerminal = status == ModelTurnTerminalProjectedStatusKind.Interrupted;
		final targetActive = request.targetKind == ModelTurnReplayTargetKind.ActiveExact;
		final targetHistorical = request.targetKind == ModelTurnReplayTargetKind.HistoricalExact;
		final fallbackActive = request.targetKind == ModelTurnReplayTargetKind.ActiveFallback && request.activeTurnPresent;
		final missingNoop = request.targetKind == ModelTurnReplayTargetKind.MissingNoop
			|| (request.targetKind == ModelTurnReplayTargetKind.ActiveFallback && !request.activeTurnPresent);
		final terminalNotification = !missingNoop && (completedTerminal || interruptedTerminal);
		final replayKindAttached = terminalNotification;
		final currentClosed = completedTerminal && (targetActive || fallbackActive);
		final currentMarkedTerminal = interruptedTerminal && (targetActive || fallbackActive);
		final activePreserved = targetHistorical || missingNoop;
		final liveSuppressed = replayKindAttached;
		final inProgressStart = request.turnWasInProgress && request.replayKind == ModelTurnReplayKind.ThreadSnapshot;
		final resumeStartSuppressed = request.turnWasInProgress && request.replayKind == ModelTurnReplayKind.ResumeInitialMessages;

		return new ModelTurnReplayReconstructionOutcome(true, "turn_replay_reconstruction_modeled", request.requestId, request.projectionOutcome.requestId,
			request.replayKind, request.targetKind, terminalTurnId, status, currentClosed, currentMarkedTerminal, targetHistorical, activePreserved,
			fallbackActive, missingNoop, request.projectionOutcome.threadHistoryFailedStatusPreserved, terminalNotification, replayKindAttached,
			inProgressStart, resumeStartSuppressed, liveSuppressed, request.projectionOutcome.lastAgentMessagePropagatedToCoreStatus,
			request.projectionOutcome.liveNetworkAttempted, request.projectionOutcome.realFilesystemMutated,
			request.projectionOutcome.toolExecutedOutsideFixture, missingNoop ? "terminal event had no active or historical replay target" : "");
	}

	static function failure(requestId:String, projectionRequestId:String, replayKind:ModelTurnReplayKind, targetKind:ModelTurnReplayTargetKind,
			terminalTurnId:String, errorMessage:String):ModelTurnReplayReconstructionOutcome {
		return new ModelTurnReplayReconstructionOutcome(false, "turn_replay_reconstruction_failed", requestId, projectionRequestId, replayKind, targetKind,
			terminalTurnId, ModelTurnTerminalProjectedStatusKind.Errored, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, errorMessage);
	}
}
