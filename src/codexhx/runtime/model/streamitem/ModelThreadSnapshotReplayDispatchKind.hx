package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotReplayDispatchKind(String) to String {
	final TurnsReplayed = "turns_replayed";
	final ChatNotification = "chat_notification";
	final ChatRequest = "chat_request";
	final HistoryEntryResponse = "history_entry_response";
	final FeedbackSubmission = "feedback_submission";
	final NoticeSuppressed = "notice_suppressed";
	final RequestFiltered = "request_filtered";
}
