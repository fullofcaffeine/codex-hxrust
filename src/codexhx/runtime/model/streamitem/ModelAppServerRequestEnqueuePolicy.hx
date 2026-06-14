package codexhx.runtime.model.streamitem;

class ModelAppServerRequestEnqueuePolicy {
	public static function enqueue(request:ModelAppServerRequestEnqueueRequest):ModelAppServerRequestEnqueueOutcome {
		if (request == null) return failure("", "", ModelReplayedServerRequestKind.UserInput, "missing app-server request enqueue request");
		final responseDispatchRequestId = request.responseDispatchOutcome == null ? "" : request.responseDispatchOutcome.requestId;
		if (request.responseDispatchOutcome != null && !request.responseDispatchOutcome.ok) {
			return failure(request.requestId, responseDispatchRequestId, request.requestKind, "app-server response dispatch outcome was not successful");
		}

		final unsupportedSkipped = request.responseDispatchOutcome != null && request.responseDispatchOutcome.rejectServerRequestIntent;
		final threadless = !request.threadIdAvailable || request.threadId.length == 0;
		final targetPrimary = request.threadIdAvailable && (!request.primaryThreadKnown || request.primaryThreadId == request.threadId);
		final primaryPending = targetPrimary && !request.primaryThreadKnown;
		final primaryThread = targetPrimary && request.primaryThreadKnown;
		final background = request.threadIdAvailable && !targetPrimary;
		final failure = !unsupportedSkipped && !threadless && !request.enqueueSucceeds;
		final queued = !failure && !unsupportedSkipped && !threadless;
		final route = routeKind(unsupportedSkipped, threadless, failure, primaryPending, primaryThread);
		final pendingPrimaryAfter = queued && primaryPending ? request.pendingPrimaryEventCountBefore + 1 : request.pendingPrimaryEventCountBefore;
		final threadQueueAfter = queued && !primaryPending ? request.threadQueueEventCountBefore + 1 : request.threadQueueEventCountBefore;
		final responseLive = request.responseDispatchOutcome != null && request.responseDispatchOutcome.liveNetworkAttempted;
		final responseFs = request.responseDispatchOutcome != null && request.responseDispatchOutcome.realFilesystemMutated;
		final responseTool = request.responseDispatchOutcome != null && request.responseDispatchOutcome.toolExecutedOutsideFixture;
		final activeThread = request.activeThreadId.length > 0 && request.activeThreadId == request.threadId;

		return new ModelAppServerRequestEnqueueOutcome(
			true,
			"app_server_request_enqueue_modeled",
			request.requestId,
			responseDispatchRequestId,
			request.requestKind,
			route,
			request.threadId,
			request.primaryThreadId,
			request.pendingRequestRecorded && !unsupportedSkipped,
			queued && primaryPending,
			queued && primaryThread,
			queued && background,
			threadless && !unsupportedSkipped,
			unsupportedSkipped,
			failure,
			queued && !primaryPending && request.pendingRequestRecorded,
			queued && request.queueActive && activeThread,
			queued && background && !activeThread,
			queued && !primaryPending && request.pendingRequestRecorded,
			queued && request.requestOrderIndex == request.previousRequestCount + 1,
			pendingPrimaryAfter,
			threadQueueAfter,
			responseLive,
			responseFs,
			responseTool,
			failure ? "failed to enqueue app-server request" : ""
		);
	}

	static function routeKind(
		unsupportedSkipped:Bool,
		threadless:Bool,
		failure:Bool,
		primaryPending:Bool,
		primaryThread:Bool
	):ModelAppServerRequestEnqueueRouteKind {
		if (unsupportedSkipped) return ModelAppServerRequestEnqueueRouteKind.UnsupportedRejectedSkip;
		if (threadless) return ModelAppServerRequestEnqueueRouteKind.ThreadlessIgnored;
		if (failure) return ModelAppServerRequestEnqueueRouteKind.EnqueueFailure;
		if (primaryPending) return ModelAppServerRequestEnqueueRouteKind.PrimaryPendingQueue;
		if (primaryThread) return ModelAppServerRequestEnqueueRouteKind.PrimaryThreadQueue;
		return ModelAppServerRequestEnqueueRouteKind.BackgroundThreadQueue;
	}

	static function failure(
		requestId:String,
		responseDispatchRequestId:String,
		requestKind:ModelReplayedServerRequestKind,
		errorMessage:String
	):ModelAppServerRequestEnqueueOutcome {
		return new ModelAppServerRequestEnqueueOutcome(
			false,
			"app_server_request_enqueue_failed",
			requestId,
			responseDispatchRequestId,
			requestKind,
			ModelAppServerRequestEnqueueRouteKind.ThreadlessIgnored,
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
			0,
			0,
			false,
			false,
			false,
			errorMessage
		);
	}
}
