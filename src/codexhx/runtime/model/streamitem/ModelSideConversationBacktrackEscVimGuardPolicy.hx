package codexhx.runtime.model.streamitem;

class ModelSideConversationBacktrackEscVimGuardPolicy {
	public static function apply(request:ModelSideConversationBacktrackEscVimGuardRequest):ModelSideConversationBacktrackEscVimGuardOutcome {
		if (request == null) return failure("", "missing side-conversation backtrack Esc Vim guard request");

		final initialBacktrackEscHandled = request.keyIsEsc
			&& !request.sideConversationActive
			&& request.normalBacktrackMode
			&& request.composerEmptyInitially
			&& !request.vimInsertModeActiveBeforeSideEsc;
		final initialSideBacktrackEscRejected = request.keyIsEsc
			&& request.sideConversationActive
			&& request.normalBacktrackMode
			&& request.composerEmptyInitially
			&& !request.vimInsertModeActiveBeforeSideEsc;
		final vimInsertEscTakesPrecedence = request.keyIsEsc
			&& request.vimModeEnabled
			&& request.vimInsertModeActiveAfterInsertKey;
		final backtrackEscHandledDuringVimInsert = request.keyIsEsc
			&& !request.sideConversationActive
			&& request.normalBacktrackMode
			&& request.composerEmptyInitially
			&& !request.vimInsertModeActiveAfterInsertKey;
		final sideBacktrackEscRejectedDuringVimInsert = request.keyIsEsc
			&& request.sideConversationActive
			&& request.normalBacktrackMode
			&& request.composerEmptyInitially
			&& !request.vimInsertModeActiveAfterInsertKey;
		final backtrackEscSuppressedDuringVimInsert = vimInsertEscTakesPrecedence && !backtrackEscHandledDuringVimInsert;
		final sideRejectionSuppressedDuringVimInsert = vimInsertEscTakesPrecedence && !sideBacktrackEscRejectedDuringVimInsert;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final guardPreserved = !initialBacktrackEscHandled
			&& initialSideBacktrackEscRejected
			&& vimInsertEscTakesPrecedence
			&& backtrackEscSuppressedDuringVimInsert
			&& sideRejectionSuppressedDuringVimInsert;
		final decisionKind = guardPreserved
			? ModelSideConversationBacktrackEscVimGuardDecisionKind.SideBacktrackRejectionGuardPreserved
			: vimInsertEscTakesPrecedence
				? ModelSideConversationBacktrackEscVimGuardDecisionKind.VimInsertEscTakesPrecedence
				: ModelSideConversationBacktrackEscVimGuardDecisionKind.SideBacktrackRejectionUnavailable;
		final ok = guardPreserved && eventOrderingPreserved;

		return new ModelSideConversationBacktrackEscVimGuardOutcome({
			ok: ok,
			code: ok ? "side_conversation_backtrack_esc_vim_guard_modeled" : "side_conversation_backtrack_esc_vim_guard_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			initialBacktrackEscHandled: initialBacktrackEscHandled,
			initialSideBacktrackEscRejected: initialSideBacktrackEscRejected,
			vimInsertEscTakesPrecedence: vimInsertEscTakesPrecedence,
			backtrackEscSuppressedDuringVimInsert: backtrackEscSuppressedDuringVimInsert,
			sideRejectionSuppressedDuringVimInsert: sideRejectionSuppressedDuringVimInsert,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "side-conversation backtrack Esc Vim guard invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelSideConversationBacktrackEscVimGuardOutcome {
		return new ModelSideConversationBacktrackEscVimGuardOutcome({
			ok: false,
			code: "side_conversation_backtrack_esc_vim_guard_failed",
			requestId: requestId,
			decisionKind: ModelSideConversationBacktrackEscVimGuardDecisionKind.SideBacktrackRejectionUnavailable,
			initialBacktrackEscHandled: false,
			initialSideBacktrackEscRejected: false,
			vimInsertEscTakesPrecedence: false,
			backtrackEscSuppressedDuringVimInsert: false,
			sideRejectionSuppressedDuringVimInsert: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
