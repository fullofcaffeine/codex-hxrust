package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppLinkDecisionKind(String) to String {
	final Accept = "accept";
	final Decline = "decline";
	final Cancel = "cancel";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppLinkDecisionKind {
		return switch value {
			case "accept": Accept;
			case "decline": Decline;
			case "cancel": Cancel;
			case "none": None;
			case _: Unknown;
		}
	}
}
