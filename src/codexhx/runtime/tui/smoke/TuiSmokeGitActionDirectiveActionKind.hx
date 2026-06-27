package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeGitActionDirectiveActionKind(String) to String {
	final Parse = "parse";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeGitActionDirectiveActionKind {
		return switch value {
			case "parse": Parse;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
