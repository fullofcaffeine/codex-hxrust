package codexhx.runtime.model.streamitem;

class ModelCancelledTurnEditPolicy {
	public static function apply(request:ModelCancelledTurnEditRequest):ModelCancelledTurnEditOutcome {
		if (request == null)
			return failure("", "missing cancelled-turn edit request");

		final latestSessionStart = latestSessionStart(request.transcriptCells);
		final userCount = usersSinceLatestSession(request.transcriptCells, latestSessionStart);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;

		if (request.pendingRollback) {
			return new ModelCancelledTurnEditOutcome({
				ok: false,
				code: "cancelled_turn_edit_rejected",
				requestId: request.requestId,
				decisionKind: ModelCancelledTurnEditDecisionKind.PendingRollbackRejected,
				userCountSinceLastSession: userCount,
				selectedNthUserMessage: -1,
				rollbackTurnCount: 0,
				usedBacktrackRollbackPath: false,
				usedFirstPromptRollbackPath: false,
				promptText: request.promptText,
				promptTextElementCount: request.promptTextElementCount,
				promptLocalImageCount: request.promptLocalImageCount,
				promptRemoteImageCount: request.promptRemoteImageCount,
				promptRemoteImageUrl: request.promptRemoteImageUrl,
				composerTextAfter: "",
				remoteImagesApplied: false,
				pendingRollbackRecorded: false,
				threadRollbackSubmitted: false,
				eventOrderingPreserved: eventOrderingPreserved,
				liveNetworkAttempted: false,
				realFilesystemMutated: false,
				toolExecutedOutsideFixture: false,
				errorMessage: "backtrack rollback already in progress"
			});
		}

		final hasLocalHistory = userCount > 0;
		final selectedNth = hasLocalHistory ? userCount - 1 : 0;
		return new ModelCancelledTurnEditOutcome({
			ok: true,
			code: "cancelled_turn_edit_modeled",
			requestId: request.requestId,
			decisionKind: hasLocalHistory ? ModelCancelledTurnEditDecisionKind.RestoredPromptWithLocalRollback : ModelCancelledTurnEditDecisionKind.RestoredFirstPromptWithoutLocalHistory,
			userCountSinceLastSession: userCount,
			selectedNthUserMessage: selectedNth,
			rollbackTurnCount: 1,
			usedBacktrackRollbackPath: hasLocalHistory,
			usedFirstPromptRollbackPath: !hasLocalHistory,
			promptText: request.promptText,
			promptTextElementCount: request.promptTextElementCount,
			promptLocalImageCount: request.promptLocalImageCount,
			promptRemoteImageCount: request.promptRemoteImageCount,
			promptRemoteImageUrl: request.promptRemoteImageUrl,
			composerTextAfter: request.promptText,
			remoteImagesApplied: request.promptRemoteImageCount > 0,
			pendingRollbackRecorded: true,
			threadRollbackSubmitted: true,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ""
		});
	}

	static function latestSessionStart(cells:Array<ModelBacktrackTranscriptCell>):Int {
		var start = 0;
		var i = 0;
		while (i < cells.length) {
			if (cells[i].cellKind == ModelBacktrackTranscriptCellKind.SessionHeader)
				start = i + 1;
			i = i + 1;
		}
		return start;
	}

	static function usersSinceLatestSession(cells:Array<ModelBacktrackTranscriptCell>, start:Int):Int {
		var count = 0;
		var i = start;
		while (i < cells.length) {
			if (cells[i].cellKind == ModelBacktrackTranscriptCellKind.User)
				count = count + 1;
			i = i + 1;
		}
		return count;
	}

	static function failure(requestId:String, errorMessage:String):ModelCancelledTurnEditOutcome {
		return new ModelCancelledTurnEditOutcome({
			ok: false,
			code: "cancelled_turn_edit_failed",
			requestId: requestId,
			decisionKind: ModelCancelledTurnEditDecisionKind.PendingRollbackRejected,
			userCountSinceLastSession: 0,
			selectedNthUserMessage: -1,
			rollbackTurnCount: 0,
			usedBacktrackRollbackPath: false,
			usedFirstPromptRollbackPath: false,
			promptText: "",
			promptTextElementCount: 0,
			promptLocalImageCount: 0,
			promptRemoteImageCount: 0,
			promptRemoteImageUrl: "",
			composerTextAfter: "",
			remoteImagesApplied: false,
			pendingRollbackRecorded: false,
			threadRollbackSubmitted: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
