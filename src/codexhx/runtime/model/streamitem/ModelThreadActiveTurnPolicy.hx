package codexhx.runtime.model.streamitem;

class ModelThreadActiveTurnPolicy {
	public static function apply(request:ModelThreadActiveTurnRequest):ModelThreadActiveTurnOutcome {
		if (request == null)
			return failure("", "", "missing thread active-turn request");
		final rebaseRequestId = request.rebaseOutcome == null ? "" : request.rebaseOutcome.requestId;
		if (request.rebaseOutcome == null)
			return failure(request.requestId, "", "missing thread session rebase outcome");
		if (!request.rebaseOutcome.ok)
			return failure(request.requestId, rebaseRequestId, "thread session rebase outcome was not successful");

		var after = request.activeTurnIdBefore;
		var restoredFromTurns = false;
		var nonmatchingCompletionIgnored = false;
		var threadClosedCleared = false;
		var explicitClearApplied = false;
		var decisionKind = ModelThreadActiveTurnDecisionKind.UnchangedNoActiveTurn;

		switch request.eventKind {
			case TurnsRestored:
				after = request.latestInProgressTurnId;
				restoredFromTurns = request.latestInProgressTurnId.length > 0;
				decisionKind = restoredFromTurns ? ModelThreadActiveTurnDecisionKind.RestoredLatestInProgress : ModelThreadActiveTurnDecisionKind.UnchangedNoActiveTurn;
			case TurnStarted:
				after = request.eventTurnId;
				decisionKind = ModelThreadActiveTurnDecisionKind.SetFromTurnStarted;
			case TurnCompleted:
				if (request.activeTurnIdBefore.length > 0 && request.activeTurnIdBefore == request.eventTurnId) {
					after = "";
					decisionKind = ModelThreadActiveTurnDecisionKind.ClearedMatchingCompletion;
				} else {
					nonmatchingCompletionIgnored = true;
					decisionKind = ModelThreadActiveTurnDecisionKind.PreservedNonmatchingCompletion;
				}
			case ThreadClosed:
				after = "";
				threadClosedCleared = true;
				decisionKind = ModelThreadActiveTurnDecisionKind.ClearedThreadClosed;
			case ClearActiveTurn:
				after = "";
				explicitClearApplied = true;
				decisionKind = ModelThreadActiveTurnDecisionKind.ClearedExplicit;
		}

		return new ModelThreadActiveTurnOutcome(true, "thread_active_turn_modeled", request.requestId, rebaseRequestId, request.eventKind, decisionKind,
			request.activeTurnIdBefore, request.eventTurnId, after, after != request.activeTurnIdBefore, restoredFromTurns, nonmatchingCompletionIgnored,
			threadClosedCleared, explicitClearApplied, request.turnsRestoredInOrder
			&& request.eventOrderIndex == request.previousEventCount + 1,
			request.rebaseOutcome.liveNetworkAttempted, request.rebaseOutcome.realFilesystemMutated, request.rebaseOutcome.toolExecutedOutsideFixture, "");
	}

	static function failure(requestId:String, rebaseRequestId:String, errorMessage:String):ModelThreadActiveTurnOutcome {
		return new ModelThreadActiveTurnOutcome(false, "thread_active_turn_failed", requestId, rebaseRequestId, ModelThreadActiveTurnEventKind.TurnsRestored,
			ModelThreadActiveTurnDecisionKind.UnchangedNoActiveTurn, "", "", "", false, false, false, false, false, false, false, false, false, errorMessage);
	}
}
