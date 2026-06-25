package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalVisualizationActionKind(String) to String {
	final Merge = "merge";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalVisualizationActionKind {
		return switch value {
			case "merge": Merge;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
