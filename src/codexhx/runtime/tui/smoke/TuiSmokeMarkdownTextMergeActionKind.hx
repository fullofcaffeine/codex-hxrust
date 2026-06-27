package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMarkdownTextMergeActionKind(String) to String {
	final Merge = "merge";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMarkdownTextMergeActionKind {
		return switch value {
			case "merge": Merge;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
