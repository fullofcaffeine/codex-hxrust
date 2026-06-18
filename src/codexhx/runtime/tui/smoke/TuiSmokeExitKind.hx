package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeExitKind(String) to String {
	final Rendered = "rendered";
	final Cancelled = "cancelled";
	final Quit = "quit";
	final Rejected = "rejected";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeExitKind {
		return switch value {
			case "rendered": Rendered;
			case "cancelled": Cancelled;
			case "quit": Quit;
			case "rejected": Rejected;
			case _: Unknown;
		}
	}
}
