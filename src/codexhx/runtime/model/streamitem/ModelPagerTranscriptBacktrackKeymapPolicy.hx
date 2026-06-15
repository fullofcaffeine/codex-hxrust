package codexhx.runtime.model.streamitem;

class ModelPagerTranscriptBacktrackKeymapPolicy {
	static final PagerCloseActionName = "close";
	static final TranscriptBacktrackActionName = "fixed.transcript_edit_previous";
	static final InterruptActionName = "chat.interrupt_turn";
	static final FixedBacktrackActionName = "fixed.backtrack";
	static final LeftBinding = "left";
	static final EscBinding = "esc";

	public static function apply(request:ModelPagerTranscriptBacktrackKeymapRequest):ModelPagerTranscriptBacktrackKeymapOutcome {
		if (request == null) return failure("", "missing pager/transcript-backtrack keymap request");

		final pagerActionNamePreserved = request.pagerActionName == PagerCloseActionName;
		final pagerBindingPreserved = request.pagerBinding == LeftBinding;
		final transcriptBacktrackActionNamePreserved = request.transcriptBacktrackActionName == TranscriptBacktrackActionName;
		final transcriptLeftBindingPreserved = request.transcriptBacktrackBinding == LeftBinding;
		final reservedCollisionDetected = request.pagerBinding == request.transcriptBacktrackBinding && request.pagerBinding != "";
		final conflictRejected = pagerActionNamePreserved
			&& transcriptBacktrackActionNamePreserved
			&& reservedCollisionDetected;
		final fixedBacktrackOverlapStillAllowed = request.interruptActionName == InterruptActionName
			&& request.fixedBacktrackActionName == FixedBacktrackActionName
			&& request.allowedBacktrackOverlapBinding == EscBinding;
		final noFalseInterruptBacktrackConflict = fixedBacktrackOverlapStillAllowed
			&& request.pagerBinding != request.allowedBacktrackOverlapBinding;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = pagerActionNamePreserved
			&& pagerBindingPreserved
			&& transcriptBacktrackActionNamePreserved
			&& transcriptLeftBindingPreserved
			&& reservedCollisionDetected
			&& conflictRejected
			&& fixedBacktrackOverlapStillAllowed
			&& noFalseInterruptBacktrackConflict
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelPagerTranscriptBacktrackKeymapDecisionKind.PagerTranscriptBacktrackConflictRejected
			: ModelPagerTranscriptBacktrackKeymapDecisionKind.PagerTranscriptBacktrackConflictMissed;

		return new ModelPagerTranscriptBacktrackKeymapOutcome({
			ok: ok,
			code: ok ? "pager_transcript_backtrack_keymap_conflict_modeled" : "pager_transcript_backtrack_keymap_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			pagerActionNamePreserved: pagerActionNamePreserved,
			pagerBindingPreserved: pagerBindingPreserved,
			transcriptBacktrackActionNamePreserved: transcriptBacktrackActionNamePreserved,
			transcriptLeftBindingPreserved: transcriptLeftBindingPreserved,
			reservedCollisionDetected: reservedCollisionDetected,
			conflictRejected: conflictRejected,
			fixedBacktrackOverlapStillAllowed: fixedBacktrackOverlapStillAllowed,
			noFalseInterruptBacktrackConflict: noFalseInterruptBacktrackConflict,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "pager/transcript-backtrack keymap conflict was not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelPagerTranscriptBacktrackKeymapOutcome {
		return new ModelPagerTranscriptBacktrackKeymapOutcome({
			ok: false,
			code: "pager_transcript_backtrack_keymap_conflict_failed",
			requestId: requestId,
			decisionKind: ModelPagerTranscriptBacktrackKeymapDecisionKind.PagerTranscriptBacktrackConflictMissed,
			pagerActionNamePreserved: false,
			pagerBindingPreserved: false,
			transcriptBacktrackActionNamePreserved: false,
			transcriptLeftBindingPreserved: false,
			reservedCollisionDetected: false,
			conflictRejected: false,
			fixedBacktrackOverlapStillAllowed: false,
			noFalseInterruptBacktrackConflict: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
