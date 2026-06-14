package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotReplayEventKind(String) to String {
	final ReplayTurns = "replay_turns";
	final BufferedNotification = "buffered_notification";
	final BufferedRequest = "buffered_request";
	final HistoryEntryResponse = "history_entry_response";
	final FeedbackSubmission = "feedback_submission";
}
