package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeApprovalDecisionKind(String) to String {
	final Accept = "accept";
	final AcceptForSession = "accept_for_session";
	final AcceptForPrefix = "accept_for_prefix";
	final Deny = "deny";
	final Decline = "decline";
	final Cancel = "cancel";
	final GrantForTurn = "grant_for_turn";
	final GrantForTurnStrict = "grant_for_turn_strict";
	final GrantForSession = "grant_for_session";
	final Unsupported = "unsupported";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeApprovalDecisionKind {
		return switch value {
			case "accept": Accept;
			case "accept_for_session": AcceptForSession;
			case "accept_for_prefix": AcceptForPrefix;
			case "deny": Deny;
			case "decline": Decline;
			case "cancel": Cancel;
			case "grant_for_turn": GrantForTurn;
			case "grant_for_turn_strict": GrantForTurnStrict;
			case "grant_for_session": GrantForSession;
			case "unsupported": Unsupported;
			case "none": None;
			case _: Unknown;
		}
	}
}
