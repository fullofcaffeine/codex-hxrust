package codexhx.runtime.model.streamitem;

enum abstract ModelThreadActiveTurnDecisionKind(String) to String {
	var RestoredLatestInProgress = "restored_latest_in_progress";
	var SetFromTurnStarted = "set_from_turn_started";
	var PreservedNonmatchingCompletion = "preserved_nonmatching_completion";
	var ClearedMatchingCompletion = "cleared_matching_completion";
	var ClearedThreadClosed = "cleared_thread_closed";
	var ClearedExplicit = "cleared_explicit";
	var UnchangedNoActiveTurn = "unchanged_no_active_turn";
}
