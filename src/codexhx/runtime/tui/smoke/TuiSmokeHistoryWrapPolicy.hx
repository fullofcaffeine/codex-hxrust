package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHistoryWrapPolicy(String) to String {
	final Terminal = "terminal";
	final Word = "word";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHistoryWrapPolicy {
		return switch value {
			case "terminal": Terminal;
			case "word": Word;
			case _: Unknown;
		}
	}
}
