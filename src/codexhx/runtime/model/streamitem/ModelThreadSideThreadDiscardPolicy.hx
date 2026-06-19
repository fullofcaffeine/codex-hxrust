package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadDiscardPolicy {
	public static function apply(request:ModelThreadSideThreadDiscardRequest):ModelThreadSideThreadDiscardOutcome {
		if (request == null)
			return failure("", "", "missing thread side-thread discard request");
		final uiSyncRequestId = request.uiSyncOutcome == null ? "" : request.uiSyncOutcome.requestId;
		if (request.uiSyncOutcome == null)
			return failure(request.requestId, "", "missing thread side-thread UI sync outcome");
		if (!request.uiSyncOutcome.ok)
			return failure(request.requestId, uiSyncRequestId, "thread side-thread UI sync outcome was not successful");

		final maybeReturnEligible = !request.overlayActive && !request.modalOrPopupActive && request.composerEmpty && request.activeSideParentKnown;
		final returnFromSideAttempted = request.maybeReturnRequested && maybeReturnEligible;

		if (request.closedSideThread) {
			return success(request, uiSyncRequestId, ModelThreadSideThreadDiscardDecisionKind.DiscardedClosedLocalState, maybeReturnEligible,
				returnFromSideAttempted, false, true, ModelThreadSideThreadInterruptKind.None, false, false, true, request.discardedThreadWasActive,
				!request.discardedThreadWasActive, true, false, false, false, true, "");
		}

		if (request.maybeReturnRequested && !maybeReturnEligible) {
			return success(request, uiSyncRequestId, ModelThreadSideThreadDiscardDecisionKind.ReturnBlocked, maybeReturnEligible, false, false, false,
				ModelThreadSideThreadInterruptKind.None, false, false, false, false, false, false, false, false, false, false, "");
		}

		if (returnFromSideAttempted && !request.selectionSucceeded) {
			return success(request, uiSyncRequestId, ModelThreadSideThreadDiscardDecisionKind.ReturnSelectionFailed, maybeReturnEligible, true, false, false,
				ModelThreadSideThreadInterruptKind.None, false, false, false, false, false, false, false, false, false, false,
				"selection failed before side cleanup");
		}

		final discardTargetSelected = request.currentThreadDisplayed && request.currentThreadIsSideThread && !request.targetIsCurrentThread;
		if (!discardTargetSelected) {
			final decision = request.targetIsCurrentThread ? ModelThreadSideThreadDiscardDecisionKind.NoDiscardSameTarget : ModelThreadSideThreadDiscardDecisionKind.NoDiscardNoSideThread;
			final returned = returnFromSideAttempted && request.selectionSucceeded && !request.activeSideParentAfterSelectionKnown;
			return success(request, uiSyncRequestId, returned ? ModelThreadSideThreadDiscardDecisionKind.ReturnedFromSide : decision, maybeReturnEligible,
				returnFromSideAttempted, returned, false, ModelThreadSideThreadInterruptKind.None, false, false, false, false, false, false, false, false,
				false, false, "");
		}

		final interruptKind = request.sideThreadHasActiveTurn ? ModelThreadSideThreadInterruptKind.TurnInterrupt : ModelThreadSideThreadInterruptKind.StartupInterrupt;
		if (!request.interruptSucceeded) {
			return success(request, uiSyncRequestId, ModelThreadSideThreadDiscardDecisionKind.DiscardFailedInterrupt, maybeReturnEligible,
				returnFromSideAttempted, false, true, interruptKind, true, false, false, false, false, false, request.keepVisibleAfterCleanupFailure, false,
				true, false, "interrupt failed before unsubscribe");
		}

		if (!request.unsubscribeSucceeded) {
			return success(request, uiSyncRequestId, ModelThreadSideThreadDiscardDecisionKind.DiscardFailedUnsubscribe, maybeReturnEligible,
				returnFromSideAttempted, false, true, interruptKind, true, true, false, false, false, false, request.keepVisibleAfterCleanupFailure, false,
				true, false, "unsubscribe failed before local cleanup");
		}

		final decision = request.sideThreadHasActiveTurn ? ModelThreadSideThreadDiscardDecisionKind.DiscardedActiveTurn : ModelThreadSideThreadDiscardDecisionKind.DiscardedStartup;
		return success(request, uiSyncRequestId, decision, maybeReturnEligible,
			returnFromSideAttempted, returnFromSideAttempted && !request.activeSideParentAfterSelectionKnown, true, interruptKind, true, true, true,
			request.discardedThreadWasActive,
			!request.discardedThreadWasActive, true, false, true, true, false, "");
	}

	static function success(request:ModelThreadSideThreadDiscardRequest, uiSyncRequestId:String, decisionKind:ModelThreadSideThreadDiscardDecisionKind,
			maybeReturnEligible:Bool, returnFromSideAttempted:Bool, returnFromSideSucceeded:Bool, discardTargetSelected:Bool,
			interruptKind:ModelThreadSideThreadInterruptKind, interruptAttempted:Bool, unsubscribeAttempted:Bool, localStateRemoved:Bool,
			activeThreadCleared:Bool, pendingApprovalsRefreshed:Bool, activeAgentLabelSynced:Bool, cleanupFailureKeptVisible:Bool,
			surfacePendingInactiveRequests:Bool, serverRpcAttempted:Bool, closedSideThreadLocalOnly:Bool,
			errorMessage:String):ModelThreadSideThreadDiscardOutcome {
		return new ModelThreadSideThreadDiscardOutcome(true, "thread_side_thread_discard_modeled", request.requestId, uiSyncRequestId, decisionKind,
			maybeReturnEligible, returnFromSideAttempted, returnFromSideSucceeded, discardTargetSelected, interruptKind, interruptAttempted,
			unsubscribeAttempted, localStateRemoved, activeThreadCleared, pendingApprovalsRefreshed, activeAgentLabelSynced, cleanupFailureKeptVisible,
			surfacePendingInactiveRequests, serverRpcAttempted,
			closedSideThreadLocalOnly, request.uiSyncOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.uiSyncOutcome.liveNetworkAttempted, request.uiSyncOutcome.realFilesystemMutated, request.uiSyncOutcome.toolExecutedOutsideFixture,
			errorMessage);
	}

	static function failure(requestId:String, uiSyncRequestId:String, errorMessage:String):ModelThreadSideThreadDiscardOutcome {
		return new ModelThreadSideThreadDiscardOutcome(false, "thread_side_thread_discard_failed", requestId, uiSyncRequestId,
			ModelThreadSideThreadDiscardDecisionKind.ReturnBlocked, false, false, false, false, ModelThreadSideThreadInterruptKind.None, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, errorMessage);
	}
}
