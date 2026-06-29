package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeInitialHistoryReplayActionKind(String) to String {
	final SessionStart = "session_start";
	final Begin = "begin";
	final Insert = "insert";
	final Finish = "finish";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeInitialHistoryReplayActionKind {
		return switch value {
			case "session_start": SessionStart;
			case "begin": Begin;
			case "insert": Insert;
			case "finish": Finish;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
