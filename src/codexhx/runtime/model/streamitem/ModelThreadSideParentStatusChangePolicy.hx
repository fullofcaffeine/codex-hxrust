package codexhx.runtime.model.streamitem;

class ModelThreadSideParentStatusChangePolicy {
	public static function apply(request:ModelThreadSideParentStatusChangeRequest):ModelThreadSideParentStatusChangeOutcome {
		if (request == null)
			return failure("", "", "missing thread side-parent status-change request");
		final pendingRequestId = request.pendingOutcome == null ? "" : request.pendingOutcome.requestId;
		if (request.pendingOutcome == null)
			return failure(request.requestId, "", "missing thread side-parent pending outcome");
		if (!request.pendingOutcome.ok)
			return failure(request.requestId, pendingRequestId, "thread side-parent pending outcome was not successful");

		final pendingStatus = request.pendingOutcome.sideParentStatusAfter;
		if (pendingStatus != ModelThreadSideParentStatusKind.None) {
			return success(request, pendingRequestId, ModelThreadSideParentStatusChangeDecisionKind.PendingStatusPrecedence, pendingStatus, true, false,
				false, false, false, false);
		}

		var after = request.sideParentStatusBefore;
		var decisionKind = ModelThreadSideParentStatusChangeDecisionKind.PreservedNoChange;
		var notificationStatusChangeApplied = false;
		var actionableStatusCleared = false;
		var terminalStatusSet = false;
		var terminalStatusPreserved = false;
		var ignoredInProgressTurn = false;

		switch request.eventKind {
			case TurnStarted:
				after = ModelThreadSideParentStatusKind.None;
				decisionKind = ModelThreadSideParentStatusChangeDecisionKind.ClearedTurnStarted;
				notificationStatusChangeApplied = true;
			case TurnCompleted:
				switch request.turnStatus {
					case Completed:
						after = ModelThreadSideParentStatusKind.Finished;
						decisionKind = ModelThreadSideParentStatusChangeDecisionKind.SetFinished;
						notificationStatusChangeApplied = true;
						terminalStatusSet = true;
					case Interrupted:
						after = ModelThreadSideParentStatusKind.Interrupted;
						decisionKind = ModelThreadSideParentStatusChangeDecisionKind.SetInterrupted;
						notificationStatusChangeApplied = true;
						terminalStatusSet = true;
					case Failed:
						after = ModelThreadSideParentStatusKind.Failed;
						decisionKind = ModelThreadSideParentStatusChangeDecisionKind.SetFailed;
						notificationStatusChangeApplied = true;
						terminalStatusSet = true;
					case InProgress:
						ignoredInProgressTurn = true;
						decisionKind = ModelThreadSideParentStatusChangeDecisionKind.IgnoredInProgressTurn;
					case None:
				}
			case ThreadClosed:
				after = ModelThreadSideParentStatusKind.Closed;
				decisionKind = ModelThreadSideParentStatusChangeDecisionKind.SetClosed;
				notificationStatusChangeApplied = true;
				terminalStatusSet = true;
			case ItemStarted | ServerRequestResolved:
				notificationStatusChangeApplied = true;
				if (isActionable(request.sideParentStatusBefore)) {
					after = ModelThreadSideParentStatusKind.None;
					actionableStatusCleared = true;
					decisionKind = ModelThreadSideParentStatusChangeDecisionKind.ClearedActionable;
				} else if (isTerminal(request.sideParentStatusBefore)) {
					terminalStatusPreserved = true;
					decisionKind = ModelThreadSideParentStatusChangeDecisionKind.PreservedTerminal;
				}
			case OtherNotification:
		}

		return success(request, pendingRequestId, decisionKind, after, false, notificationStatusChangeApplied, actionableStatusCleared, terminalStatusSet,
			terminalStatusPreserved, ignoredInProgressTurn);
	}

	static function success(request:ModelThreadSideParentStatusChangeRequest, pendingRequestId:String,
			decisionKind:ModelThreadSideParentStatusChangeDecisionKind, sideParentStatusAfter:ModelThreadSideParentStatusKind,
			pendingStatusTookPrecedence:Bool, notificationStatusChangeApplied:Bool, actionableStatusCleared:Bool, terminalStatusSet:Bool,
			terminalStatusPreserved:Bool, ignoredInProgressTurn:Bool):ModelThreadSideParentStatusChangeOutcome {
		return new ModelThreadSideParentStatusChangeOutcome(true, "thread_side_parent_status_change_modeled", request.requestId, pendingRequestId,
			request.eventKind, request.turnStatus, decisionKind, request.sideParentStatusBefore, request.pendingOutcome.sideParentStatusAfter,
			sideParentStatusAfter, pendingStatusTookPrecedence, notificationStatusChangeApplied, actionableStatusCleared, terminalStatusSet,
			terminalStatusPreserved,
			ignoredInProgressTurn, request.pendingOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.pendingOutcome.liveNetworkAttempted, request.pendingOutcome.realFilesystemMutated, request.pendingOutcome.toolExecutedOutsideFixture, "");
	}

	static function isActionable(status:ModelThreadSideParentStatusKind):Bool {
		return status == ModelThreadSideParentStatusKind.NeedsInput || status == ModelThreadSideParentStatusKind.NeedsApproval;
	}

	static function isTerminal(status:ModelThreadSideParentStatusKind):Bool {
		return status == ModelThreadSideParentStatusKind.Finished
			|| status == ModelThreadSideParentStatusKind.Interrupted
			|| status == ModelThreadSideParentStatusKind.Failed
			|| status == ModelThreadSideParentStatusKind.Closed;
	}

	static function failure(requestId:String, pendingRequestId:String, errorMessage:String):ModelThreadSideParentStatusChangeOutcome {
		return new ModelThreadSideParentStatusChangeOutcome(false, "thread_side_parent_status_change_failed", requestId, pendingRequestId,
			ModelThreadSideParentStatusChangeEventKind.OtherNotification, ModelThreadSideParentTurnStatusKind.None,
			ModelThreadSideParentStatusChangeDecisionKind.PreservedNoChange, ModelThreadSideParentStatusKind.None, ModelThreadSideParentStatusKind.None,
			ModelThreadSideParentStatusKind.None, false, false, false, false, false, false, false, false, false, false, errorMessage);
	}
}
