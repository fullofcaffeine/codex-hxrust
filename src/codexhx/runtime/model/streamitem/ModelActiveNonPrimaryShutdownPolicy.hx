package codexhx.runtime.model.streamitem;

class ModelActiveNonPrimaryShutdownPolicy {
	public static function apply(request:ModelActiveNonPrimaryShutdownRequest):ModelActiveNonPrimaryShutdownOutcome {
		if (request == null) return failure("", "", "missing active non-primary shutdown request");
		final navigationCleanupRequestId = request.navigationCleanupOutcome == null ? "" : request.navigationCleanupOutcome.requestId;
		if (request.navigationCleanupOutcome == null) return failure(request.requestId, "", "missing side-thread navigation cleanup outcome");
		if (!request.navigationCleanupOutcome.ok) return failure(request.requestId, navigationCleanupRequestId, "side-thread navigation cleanup outcome was not successful");

		final ordered = request.navigationCleanupOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1;
		if (request.eventKind != ModelActiveNonPrimaryShutdownEventKind.ThreadClosed) {
			return ignored(
				request,
				navigationCleanupRequestId,
				ModelActiveNonPrimaryShutdownDecisionKind.IgnoredNonShutdownEvent,
				true,
				false,
				false,
				false,
				false,
				false,
				true,
				ordered
			);
		}

		if (request.activeThreadId.length == 0 || request.primaryThreadId.length == 0) {
			return ignored(
				request,
				navigationCleanupRequestId,
				ModelActiveNonPrimaryShutdownDecisionKind.IgnoredMissingThreadIds,
				false,
				false,
				true,
				false,
				false,
				false,
				true,
				ordered
			);
		}

		final pendingMatchesActive = request.pendingShutdownExitThreadId.length > 0 && request.pendingShutdownExitThreadId == request.activeThreadId;
		if (pendingMatchesActive) {
			return ignored(
				request,
				navigationCleanupRequestId,
				ModelActiveNonPrimaryShutdownDecisionKind.IgnoredPendingShutdownExit,
				false,
				false,
				false,
				true,
				false,
				true,
				true,
				ordered
			);
		}

		if (request.activeThreadId == request.primaryThreadId) {
			return ignored(
				request,
				navigationCleanupRequestId,
				ModelActiveNonPrimaryShutdownDecisionKind.IgnoredPrimaryThreadShutdown,
				false,
				true,
				false,
				false,
				false,
				false,
				true,
				ordered
			);
		}

		final otherPending = request.pendingShutdownExitThreadId.length > 0 && request.pendingShutdownExitThreadId != request.activeThreadId;
		final decisionKind = otherPending
			? ModelActiveNonPrimaryShutdownDecisionKind.SwitchedToPrimaryWithOtherPendingExit
			: ModelActiveNonPrimaryShutdownDecisionKind.SwitchedToPrimary;
		return new ModelActiveNonPrimaryShutdownOutcome(
			true,
			"active_non_primary_shutdown_modeled",
			request.requestId,
			navigationCleanupRequestId,
			decisionKind,
			request.eventKind,
			request.activeThreadId,
			request.primaryThreadId,
			request.pendingShutdownExitThreadId,
			request.activeThreadId,
			request.primaryThreadId,
			true,
			false,
			false,
			false,
			false,
			otherPending,
			true,
			request.closedThreadIsSideThread,
			!request.closedThreadIsSideThread,
			true,
			request.primarySelectSucceeded,
			request.primarySelectSucceeded,
			!request.primarySelectSucceeded,
			!request.primarySelectSucceeded,
			false,
			false,
			true,
			ordered,
			request.navigationCleanupOutcome.liveNetworkAttempted,
			request.navigationCleanupOutcome.realFilesystemMutated,
			request.navigationCleanupOutcome.toolExecutedOutsideFixture,
			request.primarySelectSucceeded ? "" : "failed to switch back to main thread"
		);
	}

	static function ignored(
		request:ModelActiveNonPrimaryShutdownRequest,
		navigationCleanupRequestId:String,
		decisionKind:ModelActiveNonPrimaryShutdownDecisionKind,
		nonShutdownIgnored:Bool,
		primaryShutdownIgnored:Bool,
		missingThreadIdsIgnored:Bool,
		pendingShutdownExitIgnored:Bool,
		otherPendingExitStillSwitches:Bool,
		pendingShutdownExitMarkerCleared:Bool,
		activeEventForwarded:Bool,
		eventOrderingPreserved:Bool
	):ModelActiveNonPrimaryShutdownOutcome {
		return new ModelActiveNonPrimaryShutdownOutcome(
			true,
			"active_non_primary_shutdown_modeled",
			request.requestId,
			navigationCleanupRequestId,
			decisionKind,
			request.eventKind,
			request.activeThreadId,
			request.primaryThreadId,
			request.pendingShutdownExitThreadId,
			"",
			"",
			false,
			nonShutdownIgnored,
			primaryShutdownIgnored,
			missingThreadIdsIgnored,
			pendingShutdownExitIgnored,
			otherPendingExitStillSwitches,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			pendingShutdownExitMarkerCleared,
			activeEventForwarded,
			false,
			eventOrderingPreserved,
			request.navigationCleanupOutcome.liveNetworkAttempted,
			request.navigationCleanupOutcome.realFilesystemMutated,
			request.navigationCleanupOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function failure(requestId:String, navigationCleanupRequestId:String, errorMessage:String):ModelActiveNonPrimaryShutdownOutcome {
		return new ModelActiveNonPrimaryShutdownOutcome(
			false,
			"active_non_primary_shutdown_failed",
			requestId,
			navigationCleanupRequestId,
			ModelActiveNonPrimaryShutdownDecisionKind.IgnoredNonShutdownEvent,
			ModelActiveNonPrimaryShutdownEventKind.Other,
			"",
			"",
			"",
			"",
			"",
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}
}
