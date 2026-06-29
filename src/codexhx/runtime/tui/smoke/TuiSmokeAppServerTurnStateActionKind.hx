package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget app-server turn-state behavior. */
enum abstract TuiSmokeAppServerTurnStateActionKind(String) to String {
	final UserMessageDedupe = "user_message_dedupe";
	final AnswerCompletionStatus = "answer_completion_status";
	final FeedbackTurnId = "feedback_turn_id";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerTurnStateActionKind {
		return switch value {
			case "user_message_dedupe": UserMessageDedupe;
			case "answer_completion_status": AnswerCompletionStatus;
			case "feedback_turn_id": FeedbackTurnId;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
