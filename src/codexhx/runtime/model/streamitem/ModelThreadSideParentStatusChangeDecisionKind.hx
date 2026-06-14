package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideParentStatusChangeDecisionKind(String) to String {
	var PendingStatusPrecedence = "pending_status_precedence";
	var ClearedTurnStarted = "cleared_turn_started";
	var SetFinished = "set_finished";
	var SetInterrupted = "set_interrupted";
	var SetFailed = "set_failed";
	var SetClosed = "set_closed";
	var ClearedActionable = "cleared_actionable";
	var PreservedTerminal = "preserved_terminal";
	var PreservedNoChange = "preserved_no_change";
	var IgnoredInProgressTurn = "ignored_in_progress_turn";
}
