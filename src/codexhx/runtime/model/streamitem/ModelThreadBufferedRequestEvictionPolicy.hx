package codexhx.runtime.model.streamitem;

class ModelThreadBufferedRequestEvictionPolicy {
	public static function model(request:ModelThreadBufferedRequestEvictionRequest):ModelThreadBufferedRequestEvictionOutcome {
		if (request == null) return failure("", "", ModelReplayedServerRequestKind.UserInput, "missing thread buffered request eviction request");
		final deliveryRequestId = request.deliveryOutcome == null ? "" : request.deliveryOutcome.requestId;
		if (request.deliveryOutcome == null) return failure(request.requestId, "", request.requestKind, "missing queued request delivery outcome");
		if (!request.deliveryOutcome.ok) return failure(request.requestId, deliveryRequestId, request.requestKind, "queued request delivery outcome was not successful");
		if (request.bufferCapacity <= 0) {
			return new ModelThreadBufferedRequestEvictionOutcome(
				false,
				"thread_buffered_request_eviction_failed",
				request.requestId,
				deliveryRequestId,
				request.requestKind,
				ModelThreadBufferedRequestEvictionKind.InvalidCapacityRefused,
				request.incomingEventKind,
				request.evictedEventKind,
				false,
				false,
				false,
				request.pendingReplayRecordedBefore,
				false,
				false,
				0,
				false,
				false,
				request.deliveryOutcome.liveNetworkAttempted,
				request.deliveryOutcome.realFilesystemMutated,
				request.deliveryOutcome.toolExecutedOutsideFixture,
				"invalid thread event buffer capacity"
			);
		}

		final countAfterPush = request.bufferEventCountBefore + 1;
		final overCapacity = countAfterPush > request.bufferCapacity;
		final evictedRequestObserved = overCapacity && request.evictedEventKind == ModelThreadBufferedEventKind.Request;
		final pendingPromptRemoved = evictedRequestObserved && request.targetRequestEvicted && request.targetRequestWasPendingInteractive && request.pendingReplayRecordedBefore;
		final pendingReplayRecordedAfter = request.pendingReplayRecordedBefore && !pendingPromptRemoved;
		final snapshotRequestReplayed = request.snapshotFilterChecked && pendingReplayRecordedAfter && !request.targetRequestEvicted;
		final replaySkippedAfterEviction = request.snapshotFilterChecked && request.targetRequestEvicted && !snapshotRequestReplayed;
		final bufferCountAfter = overCapacity ? countAfterPush - 1 : countAfterPush;
		final capacityPreserved = bufferCountAfter <= request.bufferCapacity;
		final orderingPreserved = orderPreserved(request, overCapacity);
		final evictionKind = evictionKind(overCapacity, evictedRequestObserved, pendingPromptRemoved, replaySkippedAfterEviction);

		return new ModelThreadBufferedRequestEvictionOutcome(
			true,
			"thread_buffered_request_eviction_modeled",
			request.requestId,
			deliveryRequestId,
			request.requestKind,
			evictionKind,
			request.incomingEventKind,
			request.evictedEventKind,
			overCapacity,
			evictedRequestObserved,
			pendingPromptRemoved,
			pendingReplayRecordedAfter,
			snapshotRequestReplayed,
			replaySkippedAfterEviction,
			bufferCountAfter,
			capacityPreserved,
			orderingPreserved,
			request.deliveryOutcome.liveNetworkAttempted,
			request.deliveryOutcome.realFilesystemMutated,
			request.deliveryOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function evictionKind(
		overCapacity:Bool,
		evictedRequestObserved:Bool,
		pendingPromptRemoved:Bool,
		replaySkippedAfterEviction:Bool
	):ModelThreadBufferedRequestEvictionKind {
		if (!overCapacity) return ModelThreadBufferedRequestEvictionKind.BufferedRequestRetained;
		if (!evictedRequestObserved) return ModelThreadBufferedRequestEvictionKind.NonRequestEvictionIgnored;
		if (pendingPromptRemoved) return ModelThreadBufferedRequestEvictionKind.PendingPromptRemoved;
		if (replaySkippedAfterEviction) return ModelThreadBufferedRequestEvictionKind.ReplaySkippedAfterEviction;
		return ModelThreadBufferedRequestEvictionKind.BufferedRequestRetained;
	}

	static function orderPreserved(request:ModelThreadBufferedRequestEvictionRequest, overCapacity:Bool):Bool {
		if (request.incomingOrderIndex != request.bufferEventCountBefore + 1) return false;
		if (!overCapacity) return true;
		return request.evictedOrderIndex == request.incomingOrderIndex - request.bufferCapacity;
	}

	static function failure(
		requestId:String,
		deliveryRequestId:String,
		requestKind:ModelReplayedServerRequestKind,
		errorMessage:String
	):ModelThreadBufferedRequestEvictionOutcome {
		return new ModelThreadBufferedRequestEvictionOutcome(
			false,
			"thread_buffered_request_eviction_failed",
			requestId,
			deliveryRequestId,
			requestKind,
			ModelThreadBufferedRequestEvictionKind.InvalidCapacityRefused,
			ModelThreadBufferedEventKind.Request,
			ModelThreadBufferedEventKind.Notification,
			false,
			false,
			false,
			false,
			false,
			false,
			0,
			false,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}
}
