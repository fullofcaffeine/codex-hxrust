package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMcpElicitationActionKind(String) to String {
	final NoteServerRequest = "note_server_request";
	final ParseForm = "parse_form";
	final ShowModal = "show_modal";
	final ShowAppLink = "show_app_link";
	final EnqueueActive = "enqueue_active";
	final SelectOption = "select_option";
	final DraftInput = "draft_input";
	final MoveField = "move_field";
	final ValidationError = "validation_error";
	final Submit = "submit";
	final Cancel = "cancel";
	final Resolve = "resolve";
	final DismissResolved = "dismiss_resolved";
	final UnsupportedReject = "unsupported_reject";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMcpElicitationActionKind {
		return switch value {
			case "note_server_request": NoteServerRequest;
			case "parse_form": ParseForm;
			case "show_modal": ShowModal;
			case "show_app_link": ShowAppLink;
			case "enqueue_active": EnqueueActive;
			case "select_option": SelectOption;
			case "draft_input": DraftInput;
			case "move_field": MoveField;
			case "validation_error": ValidationError;
			case "submit": Submit;
			case "cancel": Cancel;
			case "resolve": Resolve;
			case "dismiss_resolved": DismissResolved;
			case "unsupported_reject": UnsupportedReject;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
