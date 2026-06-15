package codexhx.runtime.model.streamitem;

class ModelSideBacktrackUnavailableMessagePolicy {
	static final UpstreamUnavailableMessage = "Editing previous prompts is unavailable in side conversations.";
	static final UpstreamSnapshotName = "side_backtrack_rejection_reports_unavailable_message";
	static final UpstreamRenderedLine = "■ " + UpstreamUnavailableMessage;

	public static function apply(request:ModelSideBacktrackUnavailableMessageRequest):ModelSideBacktrackUnavailableMessageOutcome {
		if (request == null) return failure("", "missing side-backtrack unavailable message request");

		final backtrackPrimedAfter = request.rejectInvoked ? false : request.backtrackPrimedBefore;
		final backtrackReset = request.backtrackPrimedBefore && !backtrackPrimedAfter;
		final errorHistoryCellInserted = request.rejectInvoked && request.unavailableMessage == UpstreamUnavailableMessage;
		final insertHistoryCellIntentRecorded = errorHistoryCellInserted;
		final renderedLine = errorHistoryCellInserted ? "■ " + request.unavailableMessage : "";
		final snapshotNamePreserved = request.expectedSnapshotName == UpstreamSnapshotName;
		final widthStableSnapshot = request.renderedWidth == 80 && renderedLine == UpstreamRenderedLine;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = backtrackReset
			&& errorHistoryCellInserted
			&& insertHistoryCellIntentRecorded
			&& snapshotNamePreserved
			&& widthStableSnapshot
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelSideBacktrackUnavailableMessageDecisionKind.SideBacktrackUnavailableMessageInserted
			: ModelSideBacktrackUnavailableMessageDecisionKind.SideBacktrackUnavailableMessageUnavailable;

		return new ModelSideBacktrackUnavailableMessageOutcome({
			ok: ok,
			code: ok ? "side_backtrack_unavailable_message_modeled" : "side_backtrack_unavailable_message_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			backtrackPrimedAfter: backtrackPrimedAfter,
			backtrackReset: backtrackReset,
			errorHistoryCellInserted: errorHistoryCellInserted,
			insertHistoryCellIntentRecorded: insertHistoryCellIntentRecorded,
			renderedLine: renderedLine,
			snapshotNamePreserved: snapshotNamePreserved,
			widthStableSnapshot: widthStableSnapshot,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "side-backtrack unavailable message invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelSideBacktrackUnavailableMessageOutcome {
		return new ModelSideBacktrackUnavailableMessageOutcome({
			ok: false,
			code: "side_backtrack_unavailable_message_failed",
			requestId: requestId,
			decisionKind: ModelSideBacktrackUnavailableMessageDecisionKind.SideBacktrackUnavailableMessageUnavailable,
			backtrackPrimedAfter: false,
			backtrackReset: false,
			errorHistoryCellInserted: false,
			insertHistoryCellIntentRecorded: false,
			renderedLine: "",
			snapshotNamePreserved: false,
			widthStableSnapshot: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
