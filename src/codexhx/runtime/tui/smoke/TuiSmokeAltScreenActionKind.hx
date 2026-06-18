package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAltScreenActionKind(String) to String {
	final SetEnabled = "set_enabled";
	final Enter = "enter";
	final Leave = "leave";
	final ClearForViewportChange = "clear_for_viewport_change";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAltScreenActionKind {
		return switch value {
			case "set_enabled": SetEnabled;
			case "enter": Enter;
			case "leave": Leave;
			case "clear_for_viewport_change": ClearForViewportChange;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
