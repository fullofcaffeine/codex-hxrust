package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadUiSyncPolicy {
	public static function apply(request:ModelThreadSideThreadUiSyncRequest):ModelThreadSideThreadUiSyncOutcome {
		if (request == null) return failure("", "", "missing thread side-thread UI sync request");
		final statusChangeRequestId = request.statusChangeOutcome == null ? "" : request.statusChangeOutcome.requestId;
		if (request.statusChangeOutcome == null) return failure(request.requestId, "", "missing thread side-parent status-change outcome");
		if (!request.statusChangeOutcome.ok) return failure(request.requestId, statusChangeRequestId, "thread side-parent status-change outcome was not successful");

		final after = request.statusChangeOutcome.sideParentStatusAfter;
		final statusChanged = request.storedParentStatusBefore != after;
		final statusClearApplied = request.storedParentStatusBefore != ModelThreadSideParentStatusKind.None && after == ModelThreadSideParentStatusKind.None;
		final statusLabelApplied = after != ModelThreadSideParentStatusKind.None;

		if (!request.activeThreadDisplayed) {
			return success(request, statusChangeRequestId, ModelThreadSideThreadUiSyncDecisionKind.ClearedNoActiveThread, after, statusChanged, statusChanged, true, false, "", false,
				false, true, statusLabelApplied, statusClearApplied, false);
		}

		if (!request.sideThreadKnown) {
			return success(request, statusChangeRequestId, ModelThreadSideThreadUiSyncDecisionKind.ClearedNoSideThread, after, statusChanged, statusChanged, true, false, "", false, false,
				true, statusLabelApplied, statusClearApplied, false);
		}

		final repeatedSameStatusNoop = !statusChanged;
		final syncTriggered = statusChanged;
		final decisionKind = repeatedSameStatusNoop ? ModelThreadSideThreadUiSyncDecisionKind.SkippedSameStatus : ModelThreadSideThreadUiSyncDecisionKind.SyncedChangedStatus;
		final label = syncTriggered ? contextLabel(request.parentIsMain, request.parentThreadLabel, after) : "";

		return success(request, statusChangeRequestId, decisionKind, after, statusChanged, syncTriggered, false, syncTriggered, label, syncTriggered, syncTriggered, false,
			statusLabelApplied && syncTriggered, statusClearApplied, repeatedSameStatusNoop);
	}

	static function contextLabel(parentIsMain:Bool, parentThreadLabel:String, status:ModelThreadSideParentStatusKind):String {
		final parentPart = parentIsMain ? "from main thread" : "from parent thread (" + parentThreadLabel + ")";
		final statusPart = labelForStatus(status, parentIsMain);
		if (statusPart.length > 0) return "Side " + parentPart + " · " + statusPart + " · Ctrl+C to return";
		return "Side " + parentPart + " · Ctrl+C to return";
	}

	static function labelForStatus(status:ModelThreadSideParentStatusKind, parentIsMain:Bool):String {
		final owner = parentIsMain ? "main" : "parent";
		return switch status {
			case NeedsInput: owner + " needs input";
			case NeedsApproval: owner + " needs approval";
			case Failed: owner + " failed";
			case Interrupted: owner + " interrupted";
			case Closed: owner + " closed";
			case Finished: owner + " finished";
			case None: "";
		}
	}

	static function success(
		request:ModelThreadSideThreadUiSyncRequest,
		statusChangeRequestId:String,
		decisionKind:ModelThreadSideThreadUiSyncDecisionKind,
		storedParentStatusAfter:ModelThreadSideParentStatusKind,
		statusChanged:Bool,
		syncTriggered:Bool,
		sideUiCleared:Bool,
		sideConversationActive:Bool,
		contextLabel:String,
		renameBlocked:Bool,
		interruptedTurnNoticeSuppressed:Bool,
		interruptedTurnNoticeDefaultRestored:Bool,
		statusLabelApplied:Bool,
		statusClearApplied:Bool,
		repeatedSameStatusNoop:Bool
	):ModelThreadSideThreadUiSyncOutcome {
		return new ModelThreadSideThreadUiSyncOutcome(
			true,
			"thread_side_thread_ui_sync_modeled",
			request.requestId,
			statusChangeRequestId,
			decisionKind,
			request.storedParentStatusBefore,
			storedParentStatusAfter,
			statusChanged,
			syncTriggered,
			sideUiCleared,
			sideConversationActive,
			contextLabel,
			renameBlocked,
			interruptedTurnNoticeSuppressed,
			interruptedTurnNoticeDefaultRestored,
			statusLabelApplied,
			statusClearApplied,
			repeatedSameStatusNoop,
			request.statusChangeOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.statusChangeOutcome.liveNetworkAttempted,
			request.statusChangeOutcome.realFilesystemMutated,
			request.statusChangeOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function failure(requestId:String, statusChangeRequestId:String, errorMessage:String):ModelThreadSideThreadUiSyncOutcome {
		return new ModelThreadSideThreadUiSyncOutcome(
			false,
			"thread_side_thread_ui_sync_failed",
			requestId,
			statusChangeRequestId,
			ModelThreadSideThreadUiSyncDecisionKind.ClearedNoActiveThread,
			ModelThreadSideParentStatusKind.None,
			ModelThreadSideParentStatusKind.None,
			false,
			false,
			false,
			false,
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
			errorMessage
		);
	}
}
