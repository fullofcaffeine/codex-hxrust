package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHistorySearchDirectionKind(String) to String {
	final Older = "older";
	final Newer = "newer";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHistorySearchDirectionKind {
		return switch value {
			case "older": Older;
			case "newer": Newer;
			case "none": None;
			case _: Unknown;
		}
	}
}
