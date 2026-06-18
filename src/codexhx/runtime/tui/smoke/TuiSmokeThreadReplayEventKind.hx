package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadReplayEventKind(String) to String {
	final Notification = "notification";
	final HistoryEntryResponse = "history_entry_response";
	final FeedbackSubmission = "feedback_submission";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadReplayEventKind {
		return switch value {
			case "notification": Notification;
			case "history_entry_response": HistoryEntryResponse;
			case "feedback_submission": FeedbackSubmission;
			case _: Unknown;
		}
	}
}
