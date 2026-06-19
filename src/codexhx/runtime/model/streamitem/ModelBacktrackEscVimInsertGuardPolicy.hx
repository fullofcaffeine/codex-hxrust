package codexhx.runtime.model.streamitem;

class ModelBacktrackEscVimInsertGuardPolicy {
	public static function apply(request:ModelBacktrackEscVimInsertGuardRequest):ModelBacktrackEscVimInsertGuardOutcome {
		if (request == null)
			return failure("", "missing backtrack Esc Vim-insert guard request");

		final baseBacktrackEligible = request.keyIsEsc && !request.sideConversationActive && request.normalBacktrackMode && request.composerEmptyInitially;
		final initialBacktrackEscAllowed = baseBacktrackEligible;
		final vimNormalBacktrackEscAllowed = initialBacktrackEscAllowed && request.vimModeEnabled;
		final vimInsertEscTakesPrecedence = baseBacktrackEligible && request.vimModeEnabled && request.vimInsertModeActiveBeforeEsc;
		final backtrackEscSuppressedDuringVimInsert = vimInsertEscTakesPrecedence;
		final vimEscHandled = vimInsertEscTakesPrecedence && request.vimInsertEscHandled;
		final backtrackNotPrimedByVimEsc = vimEscHandled && !request.backtrackPrimedAfterVimEsc;
		final vimInsertClearedAfterEsc = vimEscHandled && !request.vimInsertModeActiveAfterEsc;
		final backtrackEscAllowedAfterVimEsc = baseBacktrackEligible && vimInsertClearedAfterEsc;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = backtrackEscAllowedAfterVimEsc ? ModelBacktrackEscVimInsertGuardDecisionKind.BacktrackEscGuardPreserved : vimInsertEscTakesPrecedence ? ModelBacktrackEscVimInsertGuardDecisionKind.VimInsertEscStolen : ModelBacktrackEscVimInsertGuardDecisionKind.BacktrackEscGuardUnavailable;
		final ok = initialBacktrackEscAllowed
			&& vimNormalBacktrackEscAllowed
			&& vimInsertEscTakesPrecedence
			&& backtrackEscSuppressedDuringVimInsert
			&& vimEscHandled
			&& backtrackNotPrimedByVimEsc
			&& vimInsertClearedAfterEsc
			&& backtrackEscAllowedAfterVimEsc
			&& eventOrderingPreserved;

		return new ModelBacktrackEscVimInsertGuardOutcome({
			ok: ok,
			code: ok ? "backtrack_esc_vim_insert_guard_modeled" : "backtrack_esc_vim_insert_guard_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			initialBacktrackEscAllowed: initialBacktrackEscAllowed,
			vimNormalBacktrackEscAllowed: vimNormalBacktrackEscAllowed,
			vimInsertEscTakesPrecedence: vimInsertEscTakesPrecedence,
			backtrackEscSuppressedDuringVimInsert: backtrackEscSuppressedDuringVimInsert,
			vimEscHandled: vimEscHandled,
			backtrackNotPrimedByVimEsc: backtrackNotPrimedByVimEsc,
			vimInsertClearedAfterEsc: vimInsertClearedAfterEsc,
			backtrackEscAllowedAfterVimEsc: backtrackEscAllowedAfterVimEsc,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "backtrack Esc Vim-insert guard invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelBacktrackEscVimInsertGuardOutcome {
		return new ModelBacktrackEscVimInsertGuardOutcome({
			ok: false,
			code: "backtrack_esc_vim_insert_guard_failed",
			requestId: requestId,
			decisionKind: ModelBacktrackEscVimInsertGuardDecisionKind.BacktrackEscGuardUnavailable,
			initialBacktrackEscAllowed: false,
			vimNormalBacktrackEscAllowed: false,
			vimInsertEscTakesPrecedence: false,
			backtrackEscSuppressedDuringVimInsert: false,
			vimEscHandled: false,
			backtrackNotPrimedByVimEsc: false,
			vimInsertClearedAfterEsc: false,
			backtrackEscAllowedAfterVimEsc: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
