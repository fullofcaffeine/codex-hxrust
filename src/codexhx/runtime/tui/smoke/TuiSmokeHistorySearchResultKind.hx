package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHistorySearchResultKind(String) to String {
	final Found = "found";
	final Pending = "pending";
	final AtBoundary = "at_boundary";
	final NotFound = "not_found";
	final Ignored = "ignored";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHistorySearchResultKind {
		return switch value {
			case "found": Found;
			case "pending": Pending;
			case "at_boundary": AtBoundary;
			case "not_found": NotFound;
			case "ignored": Ignored;
			case "none": None;
			case _: Unknown;
		}
	}
}
