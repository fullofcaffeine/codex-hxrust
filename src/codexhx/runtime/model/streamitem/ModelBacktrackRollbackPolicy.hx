package codexhx.runtime.model.streamitem;

class ModelBacktrackRollbackPolicy {
	public static function apply(request:ModelBacktrackRollbackRequest):ModelBacktrackRollbackOutcome {
		if (request == null)
			return failure("", "missing backtrack rollback request");

		final latestSessionStart = latestSessionStart(request.transcriptCells);
		final userCount = usersSinceLatestSession(request.transcriptCells, latestSessionStart);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final unavailable = userCount == 0 || request.pendingRollback || request.nthUserMessage < 0 || request.nthUserMessage >= userCount;
		if (unavailable) {
			return unavailableOutcome(request, userCount, eventOrderingPreserved);
		}

		final rollbackTurnCount = userCount - request.nthUserMessage;
		final prefillEmpty = request.selectionPrefill.length == 0;
		final hasTextElements = request.selectedTextElementCount > 0;
		final hasLocalImages = request.selectedLocalImageCount > 0;
		final hasRemoteImages = request.selectedRemoteImageCount > 0;
		final remoteImageOnly = prefillEmpty && !hasTextElements && !hasLocalImages && hasRemoteImages;
		final shouldSetComposer = !prefillEmpty || hasTextElements || hasLocalImages || hasRemoteImages;
		final composerDraftAfter = shouldSetComposer ? request.selectionPrefill : request.composerDraftBefore;
		final staleComposerCleared = request.composerDraftBefore.length > 0 && composerDraftAfter.length == 0 && shouldSetComposer;

		return new ModelBacktrackRollbackOutcome({
			ok: true,
			code: "backtrack_rollback_modeled",
			requestId: request.requestId,
			decisionKind: remoteImageOnly
			&& staleComposerCleared ? ModelBacktrackRollbackDecisionKind.RemoteImageOnlyClearedComposer : ModelBacktrackRollbackDecisionKind.RollbackApplied,
			userCountSinceLastSession: userCount,
			selectedNthUserMessage: request.nthUserMessage,
			prefillEmpty: prefillEmpty,
			remoteImageOnlySelection: remoteImageOnly,
			selectedTextElementCount: request.selectedTextElementCount,
			selectedLocalImageCount: request.selectedLocalImageCount,
			selectedRemoteImageCount: request.selectedRemoteImageCount,
			selectedRemoteImageUrl: request.selectedRemoteImageUrl,
			rollbackTurnCount: rollbackTurnCount,
			composerDraftBefore: request.composerDraftBefore,
			composerDraftAfter: composerDraftAfter,
			staleComposerDraftCleared: staleComposerCleared,
			remoteImagesApplied: hasRemoteImages,
			pendingRollbackRecorded: rollbackTurnCount > 0,
			threadRollbackSubmitted: rollbackTurnCount > 0,
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

	static function unavailableOutcome(request:ModelBacktrackRollbackRequest, userCount:Int, eventOrderingPreserved:Bool):ModelBacktrackRollbackOutcome {
		return new ModelBacktrackRollbackOutcome({
			ok: false,
			code: "backtrack_rollback_unavailable",
			requestId: request.requestId,
			decisionKind: ModelBacktrackRollbackDecisionKind.RollbackUnavailable,
			userCountSinceLastSession: userCount,
			selectedNthUserMessage: -1,
			prefillEmpty: request.selectionPrefill.length == 0,
			remoteImageOnlySelection: false,
			selectedTextElementCount: 0,
			selectedLocalImageCount: 0,
			selectedRemoteImageCount: 0,
			selectedRemoteImageUrl: "",
			rollbackTurnCount: 0,
			composerDraftBefore: request.composerDraftBefore,
			composerDraftAfter: request.composerDraftBefore,
			staleComposerDraftCleared: false,
			remoteImagesApplied: false,
			pendingRollbackRecorded: false,
			threadRollbackSubmitted: false,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: "rollback unavailable"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelBacktrackRollbackOutcome {
		return new ModelBacktrackRollbackOutcome({
			ok: false,
			code: "backtrack_rollback_failed",
			requestId: requestId,
			decisionKind: ModelBacktrackRollbackDecisionKind.RollbackUnavailable,
			userCountSinceLastSession: 0,
			selectedNthUserMessage: -1,
			prefillEmpty: true,
			remoteImageOnlySelection: false,
			selectedTextElementCount: 0,
			selectedLocalImageCount: 0,
			selectedRemoteImageCount: 0,
			selectedRemoteImageUrl: "",
			rollbackTurnCount: 0,
			composerDraftBefore: "",
			composerDraftAfter: "",
			staleComposerDraftCleared: false,
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
