package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDesktopThreadActionKind(String) to String {
	final Opened = "opened";
	final OpenFailed = "open_failed";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDesktopThreadActionKind {
		return switch value {
			case "opened": Opened;
			case "open_failed": OpenFailed;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
