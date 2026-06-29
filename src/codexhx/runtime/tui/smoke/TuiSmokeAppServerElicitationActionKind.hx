package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget app-server elicitation routing. */
enum abstract TuiSmokeAppServerElicitationActionKind(String) to String {
	final InvalidUrlDecline = "invalid_url_decline";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerElicitationActionKind {
		return switch value {
			case "invalid_url_decline": InvalidUrlDecline;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
