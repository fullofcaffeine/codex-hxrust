package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHistorySearchStatusKind(String) to String {
	final Idle = "idle";
	final Searching = "searching";
	final Match = "match";
	final NoMatch = "no_match";
	final Inactive = "inactive";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHistorySearchStatusKind {
		return switch value {
			case "idle": Idle;
			case "searching": Searching;
			case "match": Match;
			case "no_match": NoMatch;
			case "inactive": Inactive;
			case _: Unknown;
		}
	}
}
