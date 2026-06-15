package codexhx.runtime.model.streamitem;

class ModelFeedbackSubmissionRoutingPolicy {
	public static function route(request:ModelFeedbackSubmissionRoutingRequest):ModelFeedbackSubmissionRoutingOutcome {
		if (request == null) return failure("", "missing feedback submission routing request");
		if (request.resultOk && request.resultThreadId.length == 0) return failure(request.requestId, "successful feedback submission must include result thread id");
		if (!request.resultOk && request.resultErrorMessage.length == 0) return failure(request.requestId, "failed feedback submission must include error message");

		final replay = request.requestKind == ModelFeedbackSubmissionRequestKind.SnapshotReplay || request.snapshotReplay;
		final originBuffered = request.originThreadProvided && !replay;
		final activeSend = originBuffered && request.originThreadActive;
		final currentHistoryRendered = !request.originThreadProvided && !replay;
		final snapshotReplayRendered = replay;
		final historyCellKind = currentHistoryRendered || snapshotReplayRendered ? historyCellKind(request.resultOk) : ModelFeedbackSubmissionHistoryCellKind.None;
		final historyCellText = currentHistoryRendered || snapshotReplayRendered ? historyCellText(request.resultOk, request.resultThreadId, request.resultErrorMessage) : "";
		final ordered = request.eventOrderIndex == request.previousEventCount + 1;

		return new ModelFeedbackSubmissionRoutingOutcome({
			ok: true,
			code: "feedback_submission_routing_modeled",
			requestId: request.requestId,
			requestKind: replay ? ModelFeedbackSubmissionRequestKind.SnapshotReplay : ModelFeedbackSubmissionRequestKind.Submitted,
			decisionKind: decisionKind(replay, request.originThreadProvided, request.originThreadActive),
			category: request.category,
			includeLogs: request.includeLogs,
			feedbackSucceeded: request.resultOk,
			resultThreadId: request.resultThreadId,
			resultErrorMessage: request.resultErrorMessage,
			originThreadProvided: request.originThreadProvided,
			originThreadActive: request.originThreadActive,
			originThreadBuffered: originBuffered,
			activeThreadSendAttempted: activeSend,
			currentHistoryRendered: currentHistoryRendered,
			snapshotReplayRendered: snapshotReplayRendered,
			historyCellKind: historyCellKind,
			historyCellText: historyCellText,
			appEventEmittedImmediately: currentHistoryRendered,
			eventOrderingPreserved: ordered,
			liveFeedbackUploadAttempted: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ""
		});
	}

	static function decisionKind(
		replay:Bool,
		originThreadProvided:Bool,
		originThreadActive:Bool
	):ModelFeedbackSubmissionDecisionKind {
		if (replay) return ModelFeedbackSubmissionDecisionKind.SnapshotReplayRendered;
		if (!originThreadProvided) return ModelFeedbackSubmissionDecisionKind.CurrentHistoryRendered;
		if (originThreadActive) return ModelFeedbackSubmissionDecisionKind.ActiveOriginThreadDelivered;
		return ModelFeedbackSubmissionDecisionKind.OriginThreadBuffered;
	}

	static function historyCellKind(resultOk:Bool):ModelFeedbackSubmissionHistoryCellKind {
		return resultOk ? ModelFeedbackSubmissionHistoryCellKind.Success : ModelFeedbackSubmissionHistoryCellKind.Error;
	}

	static function historyCellText(resultOk:Bool, threadId:String, errorMessage:String):String {
		if (resultOk) return "Feedback uploaded. Please open an issue using the following URL: " + threadId;
		return "Failed to upload feedback: " + errorMessage;
	}

	static function failure(requestId:String, errorMessage:String):ModelFeedbackSubmissionRoutingOutcome {
		return new ModelFeedbackSubmissionRoutingOutcome({
			ok: false,
			code: "feedback_submission_routing_failed",
			requestId: requestId,
			requestKind: ModelFeedbackSubmissionRequestKind.Submitted,
			decisionKind: ModelFeedbackSubmissionDecisionKind.CurrentHistoryRendered,
			category: ModelFeedbackSubmissionCategory.Bug,
			includeLogs: false,
			feedbackSucceeded: false,
			resultThreadId: "",
			resultErrorMessage: "",
			originThreadProvided: false,
			originThreadActive: false,
			originThreadBuffered: false,
			activeThreadSendAttempted: false,
			currentHistoryRendered: false,
			snapshotReplayRendered: false,
			historyCellKind: ModelFeedbackSubmissionHistoryCellKind.None,
			historyCellText: "",
			appEventEmittedImmediately: false,
			eventOrderingPreserved: false,
			liveFeedbackUploadAttempted: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
