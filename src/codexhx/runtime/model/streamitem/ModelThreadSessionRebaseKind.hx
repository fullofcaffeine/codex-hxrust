package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSessionRebaseKind(String) to String {
	final SurvivedRequest = "survived_request";
	final SurvivedHookNotification = "survived_hook_notification";
	final SurvivedMcpStatusNotification = "survived_mcp_status_notification";
	final SurvivedFeedbackSubmission = "survived_feedback_submission";
	final DroppedOrdinaryNotification = "dropped_ordinary_notification";
	final DroppedHistoryEntryResponse = "dropped_history_entry_response";
	final FilteredResolvedRequest = "filtered_resolved_request";
}
