package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeApprovalActionKind(String) to String {
	final NoteServerRequest = "note_server_request";
	final ShowImmediate = "show_immediate";
	final DelayRequest = "delay_request";
	final PromoteDelayed = "promote_delayed";
	final EnqueueActive = "enqueue_active";
	final KeyDecision = "key_decision";
	final ListDecision = "list_decision";
	final Cancel = "cancel";
	final Resolve = "resolve";
	final DismissResolved = "dismiss_resolved";
	final UnsupportedReject = "unsupported_reject";
	final KeymapConflict = "keymap_conflict";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeApprovalActionKind {
		return switch value {
			case "note_server_request": NoteServerRequest;
			case "show_immediate": ShowImmediate;
			case "delay_request": DelayRequest;
			case "promote_delayed": PromoteDelayed;
			case "enqueue_active": EnqueueActive;
			case "key_decision": KeyDecision;
			case "list_decision": ListDecision;
			case "cancel": Cancel;
			case "resolve": Resolve;
			case "dismiss_resolved": DismissResolved;
			case "unsupported_reject": UnsupportedReject;
			case "keymap_conflict": KeymapConflict;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
