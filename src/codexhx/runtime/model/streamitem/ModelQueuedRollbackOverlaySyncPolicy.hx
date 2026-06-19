package codexhx.runtime.model.streamitem;

class ModelQueuedRollbackOverlaySyncPolicy {
	public static function apply(request:ModelQueuedRollbackOverlaySyncRequest):ModelQueuedRollbackOverlaySyncOutcome {
		if (request == null)
			return failure("", "missing queued rollback overlay sync request");

		final transcriptCellCountBefore = request.transcriptCells.length;
		final latestSessionStart = latestSessionStart(request.transcriptCells);
		final userPositions = userPositionsSinceLatestSession(request.transcriptCells, latestSessionStart);
		final userCountBefore = userPositions.length;
		final cutIndex = rollbackCutIndex(userPositions, request.numTurns);
		final changed = cutIndex >= 0 && cutIndex < request.transcriptCells.length;
		final cellsAfter = changed ? request.transcriptCells.slice(0, cutIndex) : request.transcriptCells.slice(0);
		final transcriptCellCountAfter = cellsAfter.length;
		final userMessagesAfter = userMessages(cellsAfter, latestSessionStart);
		final userCountAfter = userMessagesAfter.length;
		final previewSelectionAfter = previewSelectionAfter(request.overlayPreviewActive, request.nthUserMessageBefore, userCountAfter);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final overlayCommittedCellCountBefore = request.overlayActive ? transcriptCellCountBefore : 0;
		final overlayCommittedCellCountAfter = request.overlayActive
			&& changed ? transcriptCellCountAfter : overlayCommittedCellCountBefore;
		final deferredHistoryLineCountAfter = changed ? 0 : request.deferredHistoryLineCountBefore;
		final deferredHistoryCleared = changed && request.deferredHistoryLineCountBefore > 0 && deferredHistoryLineCountAfter == 0;
		final previewSelectionClamped = changed && request.overlayPreviewActive && previewSelectionAfter != request.nthUserMessageBefore;
		final backtrackRenderPending = changed;
		final overlayCommittedCountSynced = !request.overlayActive || overlayCommittedCellCountAfter == transcriptCellCountAfter;
		final agentCopyHistoryTruncated = changed && userCountAfter < userCountBefore;
		final ok = changed && eventOrderingPreserved && overlayCommittedCountSynced && deferredHistoryLineCountAfter == 0 && backtrackRenderPending;

		return new ModelQueuedRollbackOverlaySyncOutcome({
			ok: ok,
			code: ok ? "queued_rollback_overlay_sync_modeled" : "queued_rollback_overlay_sync_unchanged",
			requestId: request.requestId,
			decisionKind: ok ? ModelQueuedRollbackOverlaySyncDecisionKind.RollbackApplied : ModelQueuedRollbackOverlaySyncDecisionKind.RollbackUnchanged,
			numTurns: request.numTurns,
			transcriptCellCountBefore: transcriptCellCountBefore,
			transcriptCellCountAfter: transcriptCellCountAfter,
			userCountBefore: userCountBefore,
			userCountAfter: userCountAfter,
			userMessagesAfter: userMessagesAfter,
			overlayActive: request.overlayActive,
			overlayCommittedCellCountBefore: overlayCommittedCellCountBefore,
			overlayCommittedCellCountAfter: overlayCommittedCellCountAfter,
			overlayCommittedCountSynced: overlayCommittedCountSynced,
			deferredHistoryLineCountBefore: request.deferredHistoryLineCountBefore,
			deferredHistoryLineCountAfter: deferredHistoryLineCountAfter,
			deferredHistoryCleared: deferredHistoryCleared,
			previewSelectionBefore: request.overlayPreviewActive ? request.nthUserMessageBefore : -1,
			previewSelectionAfter: previewSelectionAfter,
			previewSelectionClamped: previewSelectionClamped,
			agentCopyHistoryUserCountAfter: changed ? userCountAfter : userCountBefore,
			agentCopyHistoryTruncated: agentCopyHistoryTruncated,
			backtrackRenderPending: backtrackRenderPending,
			eventOrderingPreserved: eventOrderingPreserved,
			liveOnlyEffectsSuppressed: true,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "queued rollback overlay sync did not apply"
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

	static function userPositionsSinceLatestSession(cells:Array<ModelBacktrackTranscriptCell>, start:Int):Array<Int> {
		final positions:Array<Int> = [];
		var i = start;
		while (i < cells.length) {
			if (cells[i].cellKind == ModelBacktrackTranscriptCellKind.User)
				positions.push(i);
			i = i + 1;
		}
		return positions;
	}

	static function rollbackCutIndex(userPositions:Array<Int>, numTurns:Int):Int {
		if (numTurns <= 0 || userPositions.length == 0)
			return -1;
		if (numTurns >= userPositions.length)
			return userPositions[0];
		return userPositions[userPositions.length - numTurns];
	}

	static function userMessages(cells:Array<ModelBacktrackTranscriptCell>, start:Int):Array<String> {
		final out:Array<String> = [];
		var i = start;
		while (i < cells.length) {
			final cell = cells[i];
			if (cell.cellKind == ModelBacktrackTranscriptCellKind.User)
				out.push(cell.message);
			i = i + 1;
		}
		return out;
	}

	static function previewSelectionAfter(active:Bool, before:Int, userCountAfter:Int):Int {
		if (!active)
			return -1;
		if (userCountAfter <= 0)
			return -1;
		final maxIndex = userCountAfter - 1;
		if (before < 0)
			return 0;
		return before < maxIndex ? before : maxIndex;
	}

	static function failure(requestId:String, errorMessage:String):ModelQueuedRollbackOverlaySyncOutcome {
		return new ModelQueuedRollbackOverlaySyncOutcome({
			ok: false,
			code: "queued_rollback_overlay_sync_failed",
			requestId: requestId,
			decisionKind: ModelQueuedRollbackOverlaySyncDecisionKind.RollbackUnchanged,
			numTurns: 0,
			transcriptCellCountBefore: 0,
			transcriptCellCountAfter: 0,
			userCountBefore: 0,
			userCountAfter: 0,
			userMessagesAfter: [],
			overlayActive: false,
			overlayCommittedCellCountBefore: 0,
			overlayCommittedCellCountAfter: 0,
			overlayCommittedCountSynced: false,
			deferredHistoryLineCountBefore: 0,
			deferredHistoryLineCountAfter: 0,
			deferredHistoryCleared: false,
			previewSelectionBefore: -1,
			previewSelectionAfter: -1,
			previewSelectionClamped: false,
			agentCopyHistoryUserCountAfter: 0,
			agentCopyHistoryTruncated: false,
			backtrackRenderPending: false,
			eventOrderingPreserved: false,
			liveOnlyEffectsSuppressed: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
