package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeUserInputActionKind(String) to String {
	final NoteServerRequest = "note_server_request";
	final ShowModal = "show_modal";
	final EnqueueActive = "enqueue_active";
	final SelectOption = "select_option";
	final OpenNotes = "open_notes";
	final DraftInput = "draft_input";
	final MoveQuestion = "move_question";
	final SubmitQuestion = "submit_question";
	final OpenUnansweredConfirmation = "open_unanswered_confirmation";
	final ConfirmUnanswered = "confirm_unanswered";
	final Cancel = "cancel";
	final Resolve = "resolve";
	final DismissResolved = "dismiss_resolved";
	final UnsupportedReject = "unsupported_reject";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeUserInputActionKind {
		return switch value {
			case "note_server_request": NoteServerRequest;
			case "show_modal": ShowModal;
			case "enqueue_active": EnqueueActive;
			case "select_option": SelectOption;
			case "open_notes": OpenNotes;
			case "draft_input": DraftInput;
			case "move_question": MoveQuestion;
			case "submit_question": SubmitQuestion;
			case "open_unanswered_confirmation": OpenUnansweredConfirmation;
			case "confirm_unanswered": ConfirmUnanswered;
			case "cancel": Cancel;
			case "resolve": Resolve;
			case "dismiss_resolved": DismissResolved;
			case "unsupported_reject": UnsupportedReject;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
