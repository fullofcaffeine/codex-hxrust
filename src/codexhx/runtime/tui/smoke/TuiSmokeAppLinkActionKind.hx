package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppLinkActionKind(String) to String {
	final NoteUrlRequest = "note_url_request";
	final ParseUrl = "parse_url";
	final ShowLink = "show_link";
	final MoveSelection = "move_selection";
	final OpenExternal = "open_external";
	final CompleteExternal = "complete_external";
	final ToggleEnabled = "toggle_enabled";
	final Decline = "decline";
	final Cancel = "cancel";
	final Resolve = "resolve";
	final DismissResolved = "dismiss_resolved";
	final UnsupportedReject = "unsupported_reject";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppLinkActionKind {
		return switch value {
			case "note_url_request": NoteUrlRequest;
			case "parse_url": ParseUrl;
			case "show_link": ShowLink;
			case "move_selection": MoveSelection;
			case "open_external": OpenExternal;
			case "complete_external": CompleteExternal;
			case "toggle_enabled": ToggleEnabled;
			case "decline": Decline;
			case "cancel": Cancel;
			case "resolve": Resolve;
			case "dismiss_resolved": DismissResolved;
			case "unsupported_reject": UnsupportedReject;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
