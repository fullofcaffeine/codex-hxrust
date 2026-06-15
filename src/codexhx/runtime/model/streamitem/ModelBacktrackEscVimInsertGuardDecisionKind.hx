package codexhx.runtime.model.streamitem;

enum abstract ModelBacktrackEscVimInsertGuardDecisionKind(String) to String {
	final BacktrackEscGuardPreserved = "backtrack_esc_guard_preserved";
	final VimInsertEscStolen = "vim_insert_esc_stolen";
	final BacktrackEscGuardUnavailable = "backtrack_esc_guard_unavailable";
}
