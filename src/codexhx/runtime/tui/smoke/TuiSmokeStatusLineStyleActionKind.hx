package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusLineStyleActionKind(String) to String {
	final Line = "line";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusLineStyleActionKind {
		return switch value {
			case "line": Line;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
