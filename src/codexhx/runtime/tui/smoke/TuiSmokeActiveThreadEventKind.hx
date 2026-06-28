package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeActiveThreadEventKind(String) to String {
	final Notification = "notification";
	final Request = "request";
	final HistoryEntryResponse = "history_entry_response";
	final FeedbackSubmission = "feedback_submission";
	final RollbackCleanup = "rollback_cleanup";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeActiveThreadEventKind {
		return switch value {
			case "notification": Notification;
			case "request": Request;
			case "history_entry_response": HistoryEntryResponse;
			case "feedback_submission": FeedbackSubmission;
			case "rollback_cleanup": RollbackCleanup;
			case _: Unknown;
		}
	}
}
