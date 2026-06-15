package codexhx.runtime.model.streamitem;

enum abstract ModelSideConversationBacktrackEscVimGuardDecisionKind(String) to String {
	final SideBacktrackRejectionGuardPreserved = "side_backtrack_rejection_guard_preserved";
	final VimInsertEscTakesPrecedence = "vim_insert_esc_takes_precedence";
	final SideBacktrackRejectionUnavailable = "side_backtrack_rejection_unavailable";
}
