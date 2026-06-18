package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMentionSearchModeKind(String) to String {
	final All = "all";
	final Files = "files";
	final Tools = "tools";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMentionSearchModeKind {
		return switch value {
			case "all": All;
			case "files": Files;
			case "tools": Tools;
			case _: Unknown;
		}
	}
}
