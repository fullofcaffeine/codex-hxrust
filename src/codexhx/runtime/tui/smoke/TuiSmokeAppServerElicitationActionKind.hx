package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget app-server elicitation routing. */
enum abstract TuiSmokeAppServerElicitationActionKind(String) to String {
	final InvalidUrlDecline = "invalid_url_decline";
	final InactiveUrlAppLink = "inactive_url_app_link";
	final InactiveInvalidUrlDecline = "inactive_invalid_url_decline";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerElicitationActionKind {
		return switch value {
			case "invalid_url_decline": InvalidUrlDecline;
			case "inactive_url_app_link": InactiveUrlAppLink;
			case "inactive_invalid_url_decline": InactiveInvalidUrlDecline;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
