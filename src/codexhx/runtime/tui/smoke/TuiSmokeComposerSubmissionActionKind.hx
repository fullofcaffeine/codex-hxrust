package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerSubmissionActionKind(String) to String {
	final PrepareText = "prepare_text";
	final HandleSubmission = "handle_submission";
	final QueueSubmission = "queue_submission";
	final DispatchBareSlash = "dispatch_bare_slash";
	final DispatchSlashArgs = "dispatch_slash_args";
	final PrepareInlineArgs = "prepare_inline_args";
	final BuildUserMessage = "build_user_message";
	final AssembleUserInput = "assemble_user_input";
	final SubmitUserTurn = "submit_user_turn";
	final QueueDrain = "queue_drain";
	final RestoreBlockedImages = "restore_blocked_images";
	final RestoreUnavailableModel = "restore_unavailable_model";
	final HistoryRecord = "history_record";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerSubmissionActionKind {
		return switch value {
			case "prepare_text": PrepareText;
			case "handle_submission": HandleSubmission;
			case "queue_submission": QueueSubmission;
			case "dispatch_bare_slash": DispatchBareSlash;
			case "dispatch_slash_args": DispatchSlashArgs;
			case "prepare_inline_args": PrepareInlineArgs;
			case "build_user_message": BuildUserMessage;
			case "assemble_user_input": AssembleUserInput;
			case "submit_user_turn": SubmitUserTurn;
			case "queue_drain": QueueDrain;
			case "restore_blocked_images": RestoreBlockedImages;
			case "restore_unavailable_model": RestoreUnavailableModel;
			case "history_record": HistoryRecord;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
