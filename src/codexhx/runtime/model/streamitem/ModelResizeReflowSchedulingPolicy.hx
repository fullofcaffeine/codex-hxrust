package codexhx.runtime.model.streamitem;

class ModelResizeReflowSchedulingPolicy {
	static final DebounceMs = 75;

	public static function apply(request:ModelResizeReflowSchedulingRequest):ModelResizeReflowSchedulingOutcome {
		if (request == null) return failure("", "", "missing resize reflow scheduling request");
		final resizeReflowRequestId = request.resizeReflowOutcome == null ? "" : request.resizeReflowOutcome.requestId;
		if (request.resizeReflowOutcome == null) return failure(request.requestId, "", "missing terminal resize reflow outcome");
		if (!request.resizeReflowOutcome.ok) return failure(request.requestId, resizeReflowRequestId, "terminal resize reflow outcome was not successful");

		final widthInitialized = request.previousObservedWidth < 0;
		final widthChanged = !widthInitialized && request.previousObservedWidth != request.currentWidth;
		final reflowNeededForWidth = !widthInitialized && request.previousReflowWidth != request.currentWidth && request.previousPendingWidth != request.currentWidth;
		final heightChanged = request.currentHeight != request.lastKnownHeight;
		final shouldRebuildTranscript = reflowNeededForWidth || heightChanged;
		final pendingReflowSet = request.terminalResizeReflowEnabled && shouldRebuildTranscript;
		final pendingTargetWidth = pendingReflowSet && reflowNeededForWidth ? request.currentWidth : -1;
		final delayedFrameRequested = pendingReflowSet;
		final immediateFrameRequested = false;
		final statusLineRefreshNeeded = request.currentWidth != request.lastKnownWidth || heightChanged;
		final streamResizeMarked = pendingReflowSet && reflowNeededForWidth && request.streamTimeSensitive;
		final reflowStateCleared = !request.terminalResizeReflowEnabled && shouldRebuildTranscript && widthChanged;
		final ordered = request.resizeReflowOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1;

		return new ModelResizeReflowSchedulingOutcome({
			ok: true,
			code: "resize_reflow_scheduling_modeled",
			requestId: request.requestId,
			resizeReflowRequestId: resizeReflowRequestId,
			decisionKind: decisionKind(request.terminalResizeReflowEnabled, shouldRebuildTranscript, heightChanged, reflowNeededForWidth),
			currentWidth: request.currentWidth,
			currentHeight: request.currentHeight,
			lastKnownWidth: request.lastKnownWidth,
			lastKnownHeight: request.lastKnownHeight,
			widthInitialized: widthInitialized,
			widthChanged: widthChanged,
			reflowNeededForWidth: reflowNeededForWidth,
			heightChanged: heightChanged,
			shouldRebuildTranscript: shouldRebuildTranscript,
			pendingReflowSet: pendingReflowSet,
			pendingTargetWidth: pendingTargetWidth,
			debounceMs: pendingReflowSet ? DebounceMs : 0,
			immediateFrameRequested: immediateFrameRequested,
			delayedFrameRequested: delayedFrameRequested,
			statusLineRefreshNeeded: statusLineRefreshNeeded,
			streamResizeMarked: streamResizeMarked,
			reflowStateCleared: reflowStateCleared,
			eventOrderingPreserved: ordered,
			liveNetworkAttempted: request.resizeReflowOutcome.liveNetworkAttempted,
			realFilesystemMutated: request.resizeReflowOutcome.realFilesystemMutated,
			toolExecutedOutsideFixture: request.resizeReflowOutcome.toolExecutedOutsideFixture,
			errorMessage: ""
		});
	}

	static function decisionKind(
		enabled:Bool,
		shouldRebuildTranscript:Bool,
		heightChanged:Bool,
		reflowNeededForWidth:Bool
	):ModelResizeReflowSchedulingDecisionKind {
		if (!shouldRebuildTranscript) return ModelResizeReflowSchedulingDecisionKind.UnchangedSizeNoOp;
		if (!enabled && reflowNeededForWidth) return ModelResizeReflowSchedulingDecisionKind.DisabledWidthChangeCleared;
		if (reflowNeededForWidth) return ModelResizeReflowSchedulingDecisionKind.WidthChangeScheduled;
		if (heightChanged) return ModelResizeReflowSchedulingDecisionKind.HeightChangeScheduled;
		return ModelResizeReflowSchedulingDecisionKind.UnchangedSizeNoOp;
	}

	static function failure(requestId:String, resizeReflowRequestId:String, errorMessage:String):ModelResizeReflowSchedulingOutcome {
		return new ModelResizeReflowSchedulingOutcome({
			ok: false,
			code: "resize_reflow_scheduling_failed",
			requestId: requestId,
			resizeReflowRequestId: resizeReflowRequestId,
			decisionKind: ModelResizeReflowSchedulingDecisionKind.UnchangedSizeNoOp,
			currentWidth: 1,
			currentHeight: 1,
			lastKnownWidth: 1,
			lastKnownHeight: 1,
			widthInitialized: false,
			widthChanged: false,
			reflowNeededForWidth: false,
			heightChanged: false,
			shouldRebuildTranscript: false,
			pendingReflowSet: false,
			pendingTargetWidth: -1,
			debounceMs: 0,
			immediateFrameRequested: false,
			delayedFrameRequested: false,
			statusLineRefreshNeeded: false,
			streamResizeMarked: false,
			reflowStateCleared: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
