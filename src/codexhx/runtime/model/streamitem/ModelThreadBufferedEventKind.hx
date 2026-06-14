package codexhx.runtime.model.streamitem;

enum abstract ModelThreadBufferedEventKind(String) to String {
	final Request = "request";
	final Notification = "notification";
	final HistoryEntryResponse = "history_entry_response";
	final FeedbackSubmission = "feedback_submission";
}
