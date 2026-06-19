package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadNavigationCleanupPolicy {
	public static function apply(request:ModelThreadSideThreadNavigationCleanupRequest):ModelThreadSideThreadNavigationCleanupOutcome {
		if (request == null)
			return failure("", "", "missing thread side-thread navigation cleanup request");
		final composerRequestId = request.composerHandoffOutcome == null ? "" : request.composerHandoffOutcome.requestId;
		if (request.composerHandoffOutcome == null)
			return failure(request.requestId, "", "missing thread side-thread composer handoff outcome");
		if (!request.composerHandoffOutcome.ok)
			return failure(request.requestId, composerRequestId, "thread side-thread composer handoff outcome was not successful");

		if (request.discardClosedNotification) {
			return removed(request, composerRequestId, ModelThreadSideThreadNavigationCleanupDecisionKind.DiscardedClosedLocalStateOnly, false, false, false,
				true, false);
		}

		if (!request.currentDisplayedThreadIsSide) {
			return noop(request, composerRequestId, ModelThreadSideThreadNavigationCleanupDecisionKind.NoDiscardNoVisibleSideThread);
		}

		if (request.targetIsCurrentSideThread) {
			return noop(request, composerRequestId, ModelThreadSideThreadNavigationCleanupDecisionKind.NoDiscardSameTarget);
		}

		final parentSwitchAttempted = request.selectedByParentSwitch || request.targetIsParentThread;
		if (parentSwitchAttempted && !request.selectTargetSucceeded) {
			return new ModelThreadSideThreadNavigationCleanupOutcome(true, "thread_side_thread_navigation_cleanup_modeled", request.requestId,
				composerRequestId, ModelThreadSideThreadNavigationCleanupDecisionKind.SelectedParentCleanupFailedKeptVisible, true, true, false, false, false,
				false, false, false, false, request.sideThreadLocalStateBefore || request.threadEventChannelBefore || request.agentNavigationEntryBefore,
				false, false, false, false, false, false, false, request.activeThreadWasSideBeforeSwitch, false,
				true, request.composerHandoffOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
				request.composerHandoffOutcome.liveNetworkAttempted, request.composerHandoffOutcome.realFilesystemMutated,
				request.composerHandoffOutcome.toolExecutedOutsideFixture, "");
		}

		if (!request.interruptSucceeded) {
			return retained(request, composerRequestId, parentSwitchAttempted,
				ModelThreadSideThreadNavigationCleanupDecisionKind.KeptLocalStateInterruptFailed, true, false);
		}

		if (!request.unsubscribeSucceeded) {
			return retained(request, composerRequestId, parentSwitchAttempted,
				ModelThreadSideThreadNavigationCleanupDecisionKind.KeptLocalStateUnsubscribeFailed, true, true);
		}

		return removed(request, composerRequestId,
			parentSwitchAttempted ? ModelThreadSideThreadNavigationCleanupDecisionKind.SelectedParentAndDiscarded : ModelThreadSideThreadNavigationCleanupDecisionKind.DiscardedServerClosed,
			parentSwitchAttempted, request.selectTargetSucceeded, true, false, request.pendingInactiveRequests && parentSwitchAttempted);
	}

	static function noop(request:ModelThreadSideThreadNavigationCleanupRequest, composerRequestId:String,
			decisionKind:ModelThreadSideThreadNavigationCleanupDecisionKind):ModelThreadSideThreadNavigationCleanupOutcome {
		return new ModelThreadSideThreadNavigationCleanupOutcome(true, "thread_side_thread_navigation_cleanup_modeled", request.requestId, composerRequestId,
			decisionKind, false, false, false, false, false, false, false, false,
			false, request.sideThreadLocalStateBefore || request.threadEventChannelBefore || request.agentNavigationEntryBefore, false, false, false, false,
			false,
			false, false, false, false,
			false, request.composerHandoffOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.composerHandoffOutcome.liveNetworkAttempted, request.composerHandoffOutcome.realFilesystemMutated,
			request.composerHandoffOutcome.toolExecutedOutsideFixture, "");
	}

	static function retained(request:ModelThreadSideThreadNavigationCleanupRequest, composerRequestId:String, parentSwitchAttempted:Bool,
			decisionKind:ModelThreadSideThreadNavigationCleanupDecisionKind, interruptAttempted:Bool,
			unsubscribeAttempted:Bool):ModelThreadSideThreadNavigationCleanupOutcome {
		return new ModelThreadSideThreadNavigationCleanupOutcome(true, "thread_side_thread_navigation_cleanup_modeled", request.requestId, composerRequestId,
			decisionKind, true, parentSwitchAttempted, parentSwitchAttempted && request.selectTargetSucceeded,
			interruptAttempted, interruptAttempted && !request.activeTurnPresent, interruptAttempted
			&& request.activeTurnPresent, unsubscribeAttempted, true,
			false, request.sideThreadLocalStateBefore || request.threadEventChannelBefore || request.agentNavigationEntryBefore, false, false, false, false,
			false,
			false, false, request.activeThreadWasSideBeforeSwitch || !request.keepVisibleSelectSucceeded, false,
			true, request.composerHandoffOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.composerHandoffOutcome.liveNetworkAttempted, request.composerHandoffOutcome.realFilesystemMutated,
			request.composerHandoffOutcome.toolExecutedOutsideFixture, "");
	}

	static function removed(request:ModelThreadSideThreadNavigationCleanupRequest, composerRequestId:String,
			decisionKind:ModelThreadSideThreadNavigationCleanupDecisionKind, parentSwitchAttempted:Bool, selectTargetSucceeded:Bool, serverRpcAttempted:Bool,
			closedSideThreadLocalOnly:Bool, pendingInactiveRequestsSurfaced:Bool):ModelThreadSideThreadNavigationCleanupOutcome {
		final interruptAttempted = serverRpcAttempted;
		return new ModelThreadSideThreadNavigationCleanupOutcome(true, "thread_side_thread_navigation_cleanup_modeled", request.requestId, composerRequestId,
			decisionKind, true, parentSwitchAttempted, selectTargetSucceeded,
			interruptAttempted, interruptAttempted && !request.activeTurnPresent, interruptAttempted
			&& request.activeTurnPresent, serverRpcAttempted,
			serverRpcAttempted, request.sideThreadLocalStateBefore || request.threadEventChannelBefore || request.agentNavigationEntryBefore, false,
			request.threadEventChannelBefore, request.sideThreadLocalStateBefore, request.agentNavigationEntryBefore, request.activeThreadIsDiscardTarget,
			!request.activeThreadIsDiscardTarget, true, pendingInactiveRequestsSurfaced, false, closedSideThreadLocalOnly,
			false, request.composerHandoffOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.composerHandoffOutcome.liveNetworkAttempted, request.composerHandoffOutcome.realFilesystemMutated,
			request.composerHandoffOutcome.toolExecutedOutsideFixture, "");
	}

	static function failure(requestId:String, composerRequestId:String, errorMessage:String):ModelThreadSideThreadNavigationCleanupOutcome {
		return new ModelThreadSideThreadNavigationCleanupOutcome(false, "thread_side_thread_navigation_cleanup_failed", requestId, composerRequestId,
			ModelThreadSideThreadNavigationCleanupDecisionKind.NoDiscardSameTarget, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, errorMessage);
	}
}
