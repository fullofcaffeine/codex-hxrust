package codexhx.runtime.model.streamitem;

class ModelAppServerQueuedRequestDeliveryPolicy {
	public static function deliver(request:ModelAppServerQueuedRequestDeliveryRequest):ModelAppServerQueuedRequestDeliveryOutcome {
		if (request == null) return failure("", "", ModelReplayedServerRequestKind.UserInput, "missing app-server queued request delivery request");
		final enqueueRequestId = request.enqueueOutcome == null ? "" : request.enqueueOutcome.requestId;
		if (request.enqueueOutcome == null) return failure(request.requestId, "", request.requestKind, "missing app-server request enqueue outcome");
		if (!request.enqueueOutcome.ok) return failure(request.requestId, enqueueRequestId, request.requestKind, "app-server request enqueue outcome was not successful");

		final queued = request.enqueueOutcome.primaryPendingEventQueued || request.enqueueOutcome.primaryThreadRequestQueued || request.enqueueOutcome.backgroundThreadRequestQueued;
		final pendingPrimaryDeferred = request.enqueueOutcome.primaryPendingEventQueued && !request.pendingPrimaryDrained;
		final eligible = queued && !pendingPrimaryDeferred;
		final pendingCheck = eligible && !request.replayDelivery;
		final delivered = eligible && (request.replayDelivery || request.requestStillPending);
		final nonPendingSkipped = eligible && !request.replayDelivery && !request.requestStillPending;
		final deliveryKind = deliveryKind(request, queued, pendingPrimaryDeferred, nonPendingSkipped, delivered);

		return new ModelAppServerQueuedRequestDeliveryOutcome(
			true,
			"app_server_queued_request_delivery_modeled",
			request.requestId,
			enqueueRequestId,
			request.requestKind,
			deliveryKind,
			request.requestStillPending,
			request.activeThreadEvent,
			request.replayDelivery && delivered,
			delivered,
			pendingCheck,
			nonPendingSkipped,
			pendingPrimaryDeferred,
			request.replayDelivery || (request.enqueueOutcome.pendingInteractiveReplayRecordingIntended && !nonPendingSkipped),
			delivered && request.deliveryOrderIndex == request.previousDeliveryCount + 1,
			request.replayDelivery,
			request.enqueueOutcome.liveNetworkAttempted,
			request.enqueueOutcome.realFilesystemMutated,
			request.enqueueOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function deliveryKind(
		request:ModelAppServerQueuedRequestDeliveryRequest,
		queued:Bool,
		pendingPrimaryDeferred:Bool,
		nonPendingSkipped:Bool,
		delivered:Bool
	):ModelAppServerQueuedRequestDeliveryKind {
		if (!queued) return ModelAppServerQueuedRequestDeliveryKind.NotQueuedSkipped;
		if (pendingPrimaryDeferred) return ModelAppServerQueuedRequestDeliveryKind.PendingPrimaryDeferred;
		if (nonPendingSkipped) return ModelAppServerQueuedRequestDeliveryKind.NonPendingSkipped;
		if (request.replayDelivery && delivered) return ModelAppServerQueuedRequestDeliveryKind.ReplayDelivered;
		if (request.activeThreadEvent && delivered) return ModelAppServerQueuedRequestDeliveryKind.ActiveThreadDelivered;
		if (delivered) return ModelAppServerQueuedRequestDeliveryKind.BackgroundBufferedDelivered;
		return ModelAppServerQueuedRequestDeliveryKind.NotQueuedSkipped;
	}

	static function failure(
		requestId:String,
		enqueueRequestId:String,
		requestKind:ModelReplayedServerRequestKind,
		errorMessage:String
	):ModelAppServerQueuedRequestDeliveryOutcome {
		return new ModelAppServerQueuedRequestDeliveryOutcome(
			false,
			"app_server_queued_request_delivery_failed",
			requestId,
			enqueueRequestId,
			requestKind,
			ModelAppServerQueuedRequestDeliveryKind.NotQueuedSkipped,
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
