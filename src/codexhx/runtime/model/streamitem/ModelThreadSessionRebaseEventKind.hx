package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSessionRebaseEventKind(String) to String {
	final Request = "request";
	final HookStartedNotification = "hook_started_notification";
	final HookCompletedNotification = "hook_completed_notification";
	final McpServerStatusUpdatedNotification = "mcp_server_status_updated_notification";
	final FeedbackSubmission = "feedback_submission";
	final OrdinaryNotification = "ordinary_notification";
	final HistoryEntryResponse = "history_entry_response";
}
