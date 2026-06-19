package codexhx.runtime.model.streamitem;

class ModelThreadSnapshotReplayDispatchPolicy {
	public static function dispatch(request:ModelThreadSnapshotReplayDispatchRequest):ModelThreadSnapshotReplayDispatchOutcome {
		if (request == null) {
			return failure("", "", ModelTurnReplayKind.ThreadSnapshot, ModelThreadSnapshotReplayEventKind.ReplayTurns,
				"missing thread snapshot replay dispatch request");
		}

		final pendingRequestId = request.pendingReplayOutcome == null ? "" : request.pendingReplayOutcome.requestId;
		final isInitialReplay = request.replayKind == ModelTurnReplayKind.ResumeInitialMessages;
		final isThreadSnapshot = request.replayKind == ModelTurnReplayKind.ThreadSnapshot;
		final isTurnReplay = request.eventKind == ModelThreadSnapshotReplayEventKind.ReplayTurns;
		final hasReplayPayload = isInitialReplay ? request.turnCount > 0 : request.turnCount > 0 || request.bufferedEventCount > 0;
		final shouldBufferReplay = isTurnReplay && request.terminalResizeReflowEnabled && hasReplayPayload;
		final noticeSuppressed = request.eventKind == ModelThreadSnapshotReplayEventKind.BufferedNotification
			&& request.suppressReplayNotices
			&& request.eventIsNotice;
		final notificationDelivered = request.eventKind == ModelThreadSnapshotReplayEventKind.BufferedNotification && !noticeSuppressed;
		final requestDelivered = request.eventKind == ModelThreadSnapshotReplayEventKind.BufferedRequest && request.snapshotRequestAllowed;
		final historyDelivered = request.eventKind == ModelThreadSnapshotReplayEventKind.HistoryEntryResponse;
		final feedbackDelivered = request.eventKind == ModelThreadSnapshotReplayEventKind.FeedbackSubmission;
		final turnsReplayed = isTurnReplay && request.turnCount > 0;
		final replayKindAttached = turnsReplayed || notificationDelivered || requestDelivered;
		final liveSuppressed = replayKindAttached || noticeSuppressed;

		return new ModelThreadSnapshotReplayDispatchOutcome(true, "thread_snapshot_replay_dispatch_modeled", request.requestId, pendingRequestId,
			request.replayKind, request.eventKind, dispatchKind(request.eventKind, noticeSuppressed, requestDelivered), shouldBufferReplay,
			shouldBufferReplay, isInitialReplay && isTurnReplay, isThreadSnapshot && isTurnReplay, isThreadSnapshot && isTurnReplay && request.inputStateAvailable,
			turnsReplayed, isInitialReplay
			&& isTurnReplay && request.pendingPrimaryEventCount > 0, noticeSuppressed, notificationDelivered, requestDelivered,
			historyDelivered, feedbackDelivered, replayKindAttached,
			liveSuppressed, request.pendingReplayOutcome != null && request.pendingReplayOutcome.liveNetworkAttempted, request.pendingReplayOutcome != null
			&& request.pendingReplayOutcome.realFilesystemMutated, request.pendingReplayOutcome != null && request.pendingReplayOutcome.toolExecutedOutsideFixture,
			"");
	}

	static function dispatchKind(eventKind:ModelThreadSnapshotReplayEventKind, noticeSuppressed:Bool,
			requestDelivered:Bool):ModelThreadSnapshotReplayDispatchKind {
		return switch eventKind {
			case ModelThreadSnapshotReplayEventKind.ReplayTurns:
				ModelThreadSnapshotReplayDispatchKind.TurnsReplayed;
			case ModelThreadSnapshotReplayEventKind.BufferedNotification:
				noticeSuppressed ? ModelThreadSnapshotReplayDispatchKind.NoticeSuppressed : ModelThreadSnapshotReplayDispatchKind.ChatNotification;
			case ModelThreadSnapshotReplayEventKind.BufferedRequest:
				requestDelivered ? ModelThreadSnapshotReplayDispatchKind.ChatRequest : ModelThreadSnapshotReplayDispatchKind.RequestFiltered;
			case ModelThreadSnapshotReplayEventKind.HistoryEntryResponse:
				ModelThreadSnapshotReplayDispatchKind.HistoryEntryResponse;
			case ModelThreadSnapshotReplayEventKind.FeedbackSubmission:
				ModelThreadSnapshotReplayDispatchKind.FeedbackSubmission;
		}
	}

	static function failure(requestId:String, pendingReplayRequestId:String, replayKind:ModelTurnReplayKind, eventKind:ModelThreadSnapshotReplayEventKind,
			errorMessage:String):ModelThreadSnapshotReplayDispatchOutcome {
		return new ModelThreadSnapshotReplayDispatchOutcome(false, "thread_snapshot_replay_dispatch_failed", requestId, pendingReplayRequestId, replayKind,
			eventKind, ModelThreadSnapshotReplayDispatchKind.RequestFiltered, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, errorMessage);
	}
}
