package codexhx.runtime.model.streamitem;

class ModelThreadSideParentPendingPolicy {
	public static function apply(request:ModelThreadSideParentPendingRequest):ModelThreadSideParentPendingOutcome {
		if (request == null)
			return failure("", "", "missing thread side-parent pending request");
		final activeTurnRequestId = request.activeTurnOutcome == null ? "" : request.activeTurnOutcome.requestId;
		if (request.activeTurnOutcome == null)
			return failure(request.requestId, "", "missing thread active-turn outcome");
		if (!request.activeTurnOutcome.ok)
			return failure(request.requestId, activeTurnRequestId, "thread active-turn outcome was not successful");

		var userInputCount = request.pendingUserInputCountBefore;
		var approvalCount = request.pendingApprovalCountBefore;
		var resolvedRequestRemoved = false;
		var evictedRequestRemoved = false;
		var threadClosedCleared = false;

		switch request.eventKind {
			case RequestQueued:
				if (request.requestAddsUserInput)
					userInputCount = userInputCount + 1;
				if (request.requestAddsApproval)
					approvalCount = approvalCount + 1;
			case ServerRequestResolved:
				if (request.requestRemovesUserInput && userInputCount > 0) {
					userInputCount = userInputCount - 1;
					resolvedRequestRemoved = true;
				}
				if (request.requestRemovesApproval && approvalCount > 0) {
					approvalCount = approvalCount - 1;
					resolvedRequestRemoved = true;
				}
			case RequestEvicted:
				if (request.requestRemovesUserInput && userInputCount > 0) {
					userInputCount = userInputCount - 1;
					evictedRequestRemoved = true;
				}
				if (request.requestRemovesApproval && approvalCount > 0) {
					approvalCount = approvalCount - 1;
					evictedRequestRemoved = true;
				}
			case ThreadClosed:
				userInputCount = 0;
				approvalCount = 0;
				threadClosedCleared = true;
			case StatusRefresh:
		}

		final storeStatus = statusFromCounts(userInputCount, approvalCount);
		final fallbackStatus = request.requestStatusFallbackAllowed ? statusForRequest(request.requestKind) : ModelThreadSideParentStatusKind.None;
		final requestStatusFallbackApplied = storeStatus == ModelThreadSideParentStatusKind.None
			&& fallbackStatus != ModelThreadSideParentStatusKind.None;
		final statusAfter = requestStatusFallbackApplied ? fallbackStatus : storeStatus;
		final decisionKind = decisionForStatus(statusAfter, requestStatusFallbackApplied);

		return new ModelThreadSideParentPendingOutcome(true, "thread_side_parent_pending_status_modeled", request.requestId, activeTurnRequestId,
			request.eventKind, decisionKind, request.requestKind, statusAfter, userInputCount, approvalCount,
			approvalCount > 0, userInputCount > 0 && approvalCount > 0 && statusAfter == ModelThreadSideParentStatusKind.NeedsInput,
			requestStatusFallbackApplied,
			resolvedRequestRemoved, evictedRequestRemoved, threadClosedCleared, request.eventOrderIndex == request.previousEventCount + 1,
			request.activeTurnOutcome.liveNetworkAttempted, request.activeTurnOutcome.realFilesystemMutated,
			request.activeTurnOutcome.toolExecutedOutsideFixture, "");
	}

	static function statusFromCounts(userInputCount:Int, approvalCount:Int):ModelThreadSideParentStatusKind {
		if (userInputCount > 0)
			return ModelThreadSideParentStatusKind.NeedsInput;
		if (approvalCount > 0)
			return ModelThreadSideParentStatusKind.NeedsApproval;
		return ModelThreadSideParentStatusKind.None;
	}

	static function statusForRequest(kind:ModelReplayedServerRequestKind):ModelThreadSideParentStatusKind {
		return switch kind {
			case UserInput: ModelThreadSideParentStatusKind.NeedsInput;
			case ExecApproval | FileChangeApproval | McpElicitation | PermissionsApproval | LegacyApplyPatchApproval | LegacyExecCommandApproval:
				ModelThreadSideParentStatusKind.NeedsApproval;
			case DynamicToolCall | AttestationGenerate | ChatgptAuthTokensRefresh: ModelThreadSideParentStatusKind.None;
		}
	}

	static function decisionForStatus(status:ModelThreadSideParentStatusKind, requestStatusFallbackApplied:Bool):ModelThreadSideParentPendingDecisionKind {
		if (requestStatusFallbackApplied)
			return ModelThreadSideParentPendingDecisionKind.UsedRequestStatusFallback;
		return switch status {
			case NeedsInput: ModelThreadSideParentPendingDecisionKind.SetNeedsInput;
			case NeedsApproval: ModelThreadSideParentPendingDecisionKind.SetNeedsApproval;
			case None | Finished | Interrupted | Failed | Closed: ModelThreadSideParentPendingDecisionKind.ClearedNoPending;
		}
	}

	static function failure(requestId:String, activeTurnRequestId:String, errorMessage:String):ModelThreadSideParentPendingOutcome {
		return new ModelThreadSideParentPendingOutcome(false, "thread_side_parent_pending_status_failed", requestId, activeTurnRequestId,
			ModelThreadSideParentPendingEventKind.StatusRefresh, ModelThreadSideParentPendingDecisionKind.PreservedNoPending,
			ModelReplayedServerRequestKind.UserInput, ModelThreadSideParentStatusKind.None, 0, 0, false, false, false, false, false, false, false, false,
			false, false, errorMessage);
	}
}
