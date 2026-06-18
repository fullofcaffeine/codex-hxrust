package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDesktopNotificationActionKind(String) to String {
	final DetectBackend = "detect_backend";
	final FocusDecision = "focus_decision";
	final Notify = "notify";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDesktopNotificationActionKind {
		return switch value {
			case "detect_backend": DetectBackend;
			case "focus_decision": FocusDecision;
			case "notify": Notify;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
