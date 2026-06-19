package codexhx.runtime.model.streamitem;

class ModelThreadSessionRebasePolicy {
	public static function rebase(request:ModelThreadSessionRebaseRequest):ModelThreadSessionRebaseOutcome {
		if (request == null)
			return failure("", "", "missing thread session rebase request");
		final evictionRequestId = request.evictionOutcome == null ? "" : request.evictionOutcome.requestId;
		if (request.evictionOutcome == null)
			return failure(request.requestId, "", "missing thread buffered request eviction outcome");
		if (!request.evictionOutcome.ok)
			return failure(request.requestId, evictionRequestId, "thread buffered request eviction outcome was not successful");

		final survives = survivesRebase(request.rebaseEventKind);
		final dropped = !survives;
		final requestEvent = request.rebaseEventKind == ModelThreadSessionRebaseEventKind.Request;
		final pendingReplayStatePreserved = request.pendingReplayRecordedBefore;
		final snapshotRequestReplayed = requestEvent && survives && request.snapshotFilterChecked && pendingReplayStatePreserved
			&& !request.serverResolutionRecordedBefore;
		final resolvedRequestFiltered = requestEvent
			&& survives
			&& request.snapshotFilterChecked
			&& request.serverResolutionRecordedBefore
			&& !snapshotRequestReplayed;
		final bufferEventCountAfter = dropped
			&& request.bufferEventCountBefore > 0 ? request.bufferEventCountBefore - 1 : request.bufferEventCountBefore;
		final orderingPreserved = dropped ? request.expectedOrderIndexAfter == 0 : request.expectedOrderIndexAfter == request.eventOrderIndexBefore;
		final rebaseKind = rebaseKind(request.rebaseEventKind, resolvedRequestFiltered);

		return new ModelThreadSessionRebaseOutcome(true, "thread_session_rebase_modeled", request.requestId, evictionRequestId, rebaseKind,
			request.rebaseEventKind, survives, dropped, pendingReplayStatePreserved, snapshotRequestReplayed, resolvedRequestFiltered, bufferEventCountAfter,
			orderingPreserved, request.evictionOutcome.liveNetworkAttempted, request.evictionOutcome.realFilesystemMutated,
			request.evictionOutcome.toolExecutedOutsideFixture, "");
	}

	static function survivesRebase(kind:ModelThreadSessionRebaseEventKind):Bool {
		return switch kind {
			case Request | HookStartedNotification | HookCompletedNotification | McpServerStatusUpdatedNotification | FeedbackSubmission: true;
			case OrdinaryNotification | HistoryEntryResponse: false;
		}
	}

	static function rebaseKind(eventKind:ModelThreadSessionRebaseEventKind, resolvedRequestFiltered:Bool):ModelThreadSessionRebaseKind {
		if (resolvedRequestFiltered)
			return ModelThreadSessionRebaseKind.FilteredResolvedRequest;
		return switch eventKind {
			case Request: ModelThreadSessionRebaseKind.SurvivedRequest;
			case HookStartedNotification | HookCompletedNotification: ModelThreadSessionRebaseKind.SurvivedHookNotification;
			case McpServerStatusUpdatedNotification: ModelThreadSessionRebaseKind.SurvivedMcpStatusNotification;
			case FeedbackSubmission: ModelThreadSessionRebaseKind.SurvivedFeedbackSubmission;
			case HistoryEntryResponse: ModelThreadSessionRebaseKind.DroppedHistoryEntryResponse;
			case OrdinaryNotification: ModelThreadSessionRebaseKind.DroppedOrdinaryNotification;
		}
	}

	static function failure(requestId:String, evictionRequestId:String, errorMessage:String):ModelThreadSessionRebaseOutcome {
		return new ModelThreadSessionRebaseOutcome(false, "thread_session_rebase_failed", requestId, evictionRequestId,
			ModelThreadSessionRebaseKind.DroppedOrdinaryNotification, ModelThreadSessionRebaseEventKind.OrdinaryNotification, false, false, false, false,
			false, 0, false, false, false, false, errorMessage);
	}
}
