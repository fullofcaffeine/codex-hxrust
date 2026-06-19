package codexhx.runtime.model.streamitem;

class ModelThreadRollbackResponseActiveQueueFlushPolicy {
	public static function apply(request:ModelThreadRollbackResponseActiveQueueFlushRequest):ModelThreadRollbackResponseActiveQueueFlushOutcome {
		if (request == null)
			return failure("", "missing rollback response active queue flush request");

		final activeThreadMatched = request.activeThreadId.length > 0 && request.activeThreadId == request.rollbackThreadId;
		final threadStoreRollbackApplied = request.threadChannelKnown && request.rollbackThreadId.length > 0 && request.numTurns > 0;
		final shouldDrainReceiver = activeThreadMatched && request.receiverAttachedBefore;
		final drainedActiveEventCount = shouldDrainReceiver ? request.queuedActiveEventCountBefore : 0;
		final queuedActiveEventCountAfter = shouldDrainReceiver
			&& !request.receiverDisconnectedDuringDrain ? 0 : request.queuedActiveEventCountBefore;
		final receiverAttachedAfter = shouldDrainReceiver
			&& !request.receiverDisconnectedDuringDrain ? true : request.receiverAttachedBefore
				&& !request.receiverDisconnectedDuringDrain;
		final receiverClearedAfterDisconnect = shouldDrainReceiver && request.receiverDisconnectedDuringDrain;
		final staleNotificationDiscarded = shouldDrainReceiver
			&& request.queuedStaleNotificationCountBefore > 0
			&& drainedActiveEventCount >= request.queuedStaleNotificationCountBefore
			&& queuedActiveEventCountAfter == 0;
		final applyThreadRollbackEventQueued = request.numTurns > 0 && !request.pendingBacktrackRollback;
		final pendingBacktrackFinished = request.numTurns > 0 && request.pendingBacktrackRollback;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = activeThreadMatched && threadStoreRollbackApplied && request.receiverAttachedBefore && receiverAttachedAfter
			&& !receiverClearedAfterDisconnect && staleNotificationDiscarded && queuedActiveEventCountAfter == 0 && eventOrderingPreserved;

		return new ModelThreadRollbackResponseActiveQueueFlushOutcome({
			ok: ok,
			code: ok ? "thread_rollback_response_active_queue_flushed" : "thread_rollback_response_active_queue_unchanged",
			requestId: request.requestId,
			decisionKind: ok ? ModelThreadRollbackResponseActiveQueueFlushDecisionKind.ActiveQueueFlushed : ModelThreadRollbackResponseActiveQueueFlushDecisionKind.ActiveQueueUnchanged,
			numTurns: request.numTurns,
			activeThreadMatched: activeThreadMatched,
			threadStoreRollbackApplied: threadStoreRollbackApplied,
			receiverAttachedBefore: request.receiverAttachedBefore,
			receiverAttachedAfter: receiverAttachedAfter,
			receiverClearedAfterDisconnect: receiverClearedAfterDisconnect,
			queuedActiveEventCountBefore: request.queuedActiveEventCountBefore,
			drainedActiveEventCount: drainedActiveEventCount,
			queuedActiveEventCountAfter: queuedActiveEventCountAfter,
			staleNotificationDiscarded: staleNotificationDiscarded,
			applyThreadRollbackEventQueued: applyThreadRollbackEventQueued,
			pendingBacktrackFinished: pendingBacktrackFinished,
			eventOrderingPreserved: eventOrderingPreserved,
			liveOnlyEffectsSuppressed: true,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "rollback response active queue was not flushed"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelThreadRollbackResponseActiveQueueFlushOutcome {
		return new ModelThreadRollbackResponseActiveQueueFlushOutcome({
			ok: false,
			code: "thread_rollback_response_active_queue_flush_failed",
			requestId: requestId,
			decisionKind: ModelThreadRollbackResponseActiveQueueFlushDecisionKind.ActiveQueueUnchanged,
			numTurns: 0,
			activeThreadMatched: false,
			threadStoreRollbackApplied: false,
			receiverAttachedBefore: false,
			receiverAttachedAfter: false,
			receiverClearedAfterDisconnect: false,
			queuedActiveEventCountBefore: 0,
			drainedActiveEventCount: 0,
			queuedActiveEventCountAfter: 0,
			staleNotificationDiscarded: false,
			applyThreadRollbackEventQueued: false,
			pendingBacktrackFinished: false,
			eventOrderingPreserved: false,
			liveOnlyEffectsSuppressed: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
