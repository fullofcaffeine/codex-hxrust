package codexhx.runtime.tui.smoke;

enum abstract TuiSmokePromptArgsActionKind(String) to String {
	final Parse = "parse";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokePromptArgsActionKind {
		return switch value {
			case "parse": Parse;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
