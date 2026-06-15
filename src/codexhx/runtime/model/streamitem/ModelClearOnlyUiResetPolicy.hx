package codexhx.runtime.model.streamitem;

class ModelClearOnlyUiResetPolicy {
	public static function apply(request:ModelClearOnlyUiResetRequest):ModelClearOnlyUiResetOutcome {
		if (request == null) return failure("", "missing clear-only UI reset request");

		final resetAvailable = request.resetInvoked;
		final overlayCleared = resetAvailable;
		final transcriptCleared = resetAvailable;
		final deferredHistoryCleared = resetAvailable;
		final historyEmittedFlagReset = resetAvailable;
		final transcriptReflowCleared = resetAvailable;
		final initialHistoryReplayBufferCleared = resetAvailable;
		final backtrackPrimedCleared = resetAvailable;
		final backtrackPreviewCleared = resetAvailable;
		final backtrackPendingRollbackCleared = resetAvailable;
		final backtrackRenderPendingCleared = resetAvailable;
		final skillWarningsCleared = resetAvailable;
		final chatSessionThreadPreserved = resetAvailable
			&& request.threadId.length > 0
			&& request.chatSessionThreadPresentBefore;
		final composerDraftPreserved = resetAvailable && request.composerDraftBefore.length > 0;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = resetAvailable
			? ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetApplied
			: request.threadId.length > 0
				? ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetSkipped
				: ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetUnavailable;
		final ok = resetAvailable
			&& overlayCleared
			&& transcriptCleared
			&& deferredHistoryCleared
			&& historyEmittedFlagReset
			&& transcriptReflowCleared
			&& initialHistoryReplayBufferCleared
			&& backtrackPrimedCleared
			&& backtrackPreviewCleared
			&& backtrackPendingRollbackCleared
			&& backtrackRenderPendingCleared
			&& skillWarningsCleared
			&& chatSessionThreadPreserved
			&& composerDraftPreserved
			&& eventOrderingPreserved;

		return new ModelClearOnlyUiResetOutcome({
			ok: ok,
			code: ok ? "clear_only_ui_reset_modeled" : "clear_only_ui_reset_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			resetInvoked: request.resetInvoked,
			overlayCleared: overlayCleared,
			transcriptCleared: transcriptCleared,
			deferredHistoryCleared: deferredHistoryCleared,
			historyEmittedFlagReset: historyEmittedFlagReset,
			transcriptReflowCleared: transcriptReflowCleared,
			initialHistoryReplayBufferCleared: initialHistoryReplayBufferCleared,
			backtrackPrimedCleared: backtrackPrimedCleared,
			backtrackPreviewCleared: backtrackPreviewCleared,
			backtrackPendingRollbackCleared: backtrackPendingRollbackCleared,
			backtrackRenderPendingCleared: backtrackRenderPendingCleared,
			skillWarningsCleared: skillWarningsCleared,
			chatSessionThreadPreserved: chatSessionThreadPreserved,
			composerDraftPreserved: composerDraftPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "clear-only UI reset invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelClearOnlyUiResetOutcome {
		return new ModelClearOnlyUiResetOutcome({
			ok: false,
			code: "clear_only_ui_reset_failed",
			requestId: requestId,
			decisionKind: ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetUnavailable,
			resetInvoked: false,
			overlayCleared: false,
			transcriptCleared: false,
			deferredHistoryCleared: false,
			historyEmittedFlagReset: false,
			transcriptReflowCleared: false,
			initialHistoryReplayBufferCleared: false,
			backtrackPrimedCleared: false,
			backtrackPreviewCleared: false,
			backtrackPendingRollbackCleared: false,
			backtrackRenderPendingCleared: false,
			skillWarningsCleared: false,
			chatSessionThreadPreserved: false,
			composerDraftPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
