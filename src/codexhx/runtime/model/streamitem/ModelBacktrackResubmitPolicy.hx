package codexhx.runtime.model.streamitem;

class ModelBacktrackResubmitPolicy {
	public static function apply(request:ModelBacktrackResubmitRequest):ModelBacktrackResubmitOutcome {
		if (request == null)
			return failure("", "missing backtrack resubmit request");

		final latestSessionStart = latestSessionStart(request.transcriptCells);
		final userCount = usersSinceLatestSession(request.transcriptCells, latestSessionStart);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final rollbackTurnCount = userCount > request.nthUserMessage ? userCount - request.nthUserMessage : 0;
		final canResubmit = request.sessionConfigured
			&& request.modelSupportsImages
			&& rollbackTurnCount > 0
			&& request.selectedRemoteImageCount > 0
			&& startsWith(request.selectedRemoteImageUrl, "data:image/");

		if (!canResubmit) {
			return new ModelBacktrackResubmitOutcome({
				ok: false,
				code: "backtrack_resubmit_blocked",
				requestId: request.requestId,
				decisionKind: ModelBacktrackResubmitDecisionKind.ResubmitBlocked,
				userCountSinceLastSession: userCount,
				selectedNthUserMessage: -1,
				rollbackTurnCount: 0,
				composerTextAfterRollback: request.selectionPrefill,
				composerRemoteImageCountAfterRollback: request.selectedRemoteImageCount,
				submittedImageItemCount: 0,
				submittedTextItemCount: 0,
				submittedImageUrl: "",
				dataImageUrlPreserved: false,
				imageItemBeforeTextItem: false,
				rollbackSubmitted: false,
				userTurnSubmitted: false,
				eventOrderingPreserved: eventOrderingPreserved,
				liveNetworkAttempted: false,
				realFilesystemMutated: false,
				toolExecutedOutsideFixture: false,
				errorMessage: "resubmit blocked"
			});
		}

		return new ModelBacktrackResubmitOutcome({
			ok: true,
			code: "backtrack_resubmit_modeled",
			requestId: request.requestId,
			decisionKind: ModelBacktrackResubmitDecisionKind.DataImageUrlPreserved,
			userCountSinceLastSession: userCount,
			selectedNthUserMessage: request.nthUserMessage,
			rollbackTurnCount: rollbackTurnCount,
			composerTextAfterRollback: request.selectionPrefill,
			composerRemoteImageCountAfterRollback: request.selectedRemoteImageCount,
			submittedImageItemCount: request.selectedRemoteImageCount,
			submittedTextItemCount: request.selectionPrefill.length > 0 ? 1 : 0,
			submittedImageUrl: request.selectedRemoteImageUrl,
			dataImageUrlPreserved: true,
			imageItemBeforeTextItem: request.selectionPrefill.length > 0,
			rollbackSubmitted: true,
			userTurnSubmitted: true,
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

	static function startsWith(value:String, prefix:String):Bool {
		return value != null && value.indexOf(prefix) == 0;
	}

	static function failure(requestId:String, errorMessage:String):ModelBacktrackResubmitOutcome {
		return new ModelBacktrackResubmitOutcome({
			ok: false,
			code: "backtrack_resubmit_failed",
			requestId: requestId,
			decisionKind: ModelBacktrackResubmitDecisionKind.ResubmitBlocked,
			userCountSinceLastSession: 0,
			selectedNthUserMessage: -1,
			rollbackTurnCount: 0,
			composerTextAfterRollback: "",
			composerRemoteImageCountAfterRollback: 0,
			submittedImageItemCount: 0,
			submittedTextItemCount: 0,
			submittedImageUrl: "",
			dataImageUrlPreserved: false,
			imageItemBeforeTextItem: false,
			rollbackSubmitted: false,
			userTurnSubmitted: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
