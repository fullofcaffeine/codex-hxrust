package codexhx.runtime.model.streamitem;

class ModelBacktrackSelectionPolicy {
	public static function apply(request:ModelBacktrackSelectionRequest):ModelBacktrackSelectionOutcome {
		if (request == null)
			return failure("", "missing backtrack selection request");

		final totalUserCount = totalUsers(request.transcriptCells);
		final latestSessionStart = latestSessionStart(request.transcriptCells);
		final sessionUserCount = usersSinceLatestSession(request.transcriptCells, latestSessionStart);
		final duplicateHistoryIgnored = totalUserCount > sessionUserCount && latestSessionStart > 0;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;

		if (!request.primed
			|| !request.hasBaseThread
			|| request.pendingRollback
			|| request.nthUserMessage < 0
			|| request.nthUserMessage >= sessionUserCount) {
			return new ModelBacktrackSelectionOutcome({
				ok: false,
				code: "backtrack_selection_unavailable",
				requestId: request.requestId,
				decisionKind: ModelBacktrackSelectionDecisionKind.SelectionUnavailable,
				userCountSinceLastSession: sessionUserCount,
				selectedNthUserMessage: -1,
				selectedPrefill: "",
				selectedTextElementCount: 0,
				selectedLocalImageCount: 0,
				selectedRemoteImageCount: 0,
				selectedLocalImagePath: "",
				selectedRemoteImageUrl: "",
				rollbackTurnCount: 0,
				remoteImagesApplied: false,
				composerPrefilled: false,
				pendingRollbackRecorded: false,
				threadRollbackSubmitted: false,
				duplicateHistoryIgnoredBeforeLastSession: duplicateHistoryIgnored,
				eventOrderingPreserved: eventOrderingPreserved,
				liveNetworkAttempted: false,
				realFilesystemMutated: false,
				toolExecutedOutsideFixture: false,
				errorMessage: "selection unavailable"
			});
		}

		final selected = nthUserSinceLatestSession(request.transcriptCells, latestSessionStart, request.nthUserMessage);
		if (selected == null)
			return failure(request.requestId, "selected user message not found");

		final rollbackTurnCount = sessionUserCount - request.nthUserMessage;
		final hasComposerContent = selected.message.length > 0 || selected.textElementCount > 0 || selected.localImageCount > 0
			|| selected.remoteImageCount > 0;

		return new ModelBacktrackSelectionOutcome({
			ok: true,
			code: "backtrack_selection_modeled",
			requestId: request.requestId,
			decisionKind: ModelBacktrackSelectionDecisionKind.EditedDuplicateUserTurnSelected,
			userCountSinceLastSession: sessionUserCount,
			selectedNthUserMessage: request.nthUserMessage,
			selectedPrefill: selected.message,
			selectedTextElementCount: selected.textElementCount,
			selectedLocalImageCount: selected.localImageCount,
			selectedRemoteImageCount: selected.remoteImageCount,
			selectedLocalImagePath: selected.localImagePath,
			selectedRemoteImageUrl: selected.remoteImageUrl,
			rollbackTurnCount: rollbackTurnCount,
			remoteImagesApplied: selected.remoteImageCount > 0,
			composerPrefilled: hasComposerContent,
			pendingRollbackRecorded: rollbackTurnCount > 0,
			threadRollbackSubmitted: rollbackTurnCount > 0,
			duplicateHistoryIgnoredBeforeLastSession: duplicateHistoryIgnored,
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

	static function totalUsers(cells:Array<ModelBacktrackTranscriptCell>):Int {
		var count = 0;
		for (cell in cells)
			if (cell.cellKind == ModelBacktrackTranscriptCellKind.User)
				count = count + 1;
		return count;
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

	static function nthUserSinceLatestSession(cells:Array<ModelBacktrackTranscriptCell>, start:Int, nth:Int):ModelBacktrackTranscriptCell {
		var count = 0;
		var i = start;
		while (i < cells.length) {
			final cell = cells[i];
			if (cell.cellKind == ModelBacktrackTranscriptCellKind.User) {
				if (count == nth)
					return cell;
				count = count + 1;
			}
			i = i + 1;
		}
		return null;
	}

	static function failure(requestId:String, errorMessage:String):ModelBacktrackSelectionOutcome {
		return new ModelBacktrackSelectionOutcome({
			ok: false,
			code: "backtrack_selection_failed",
			requestId: requestId,
			decisionKind: ModelBacktrackSelectionDecisionKind.SelectionUnavailable,
			userCountSinceLastSession: 0,
			selectedNthUserMessage: -1,
			selectedPrefill: "",
			selectedTextElementCount: 0,
			selectedLocalImageCount: 0,
			selectedRemoteImageCount: 0,
			selectedLocalImagePath: "",
			selectedRemoteImageUrl: "",
			rollbackTurnCount: 0,
			remoteImagesApplied: false,
			composerPrefilled: false,
			pendingRollbackRecorded: false,
			threadRollbackSubmitted: false,
			duplicateHistoryIgnoredBeforeLastSession: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
