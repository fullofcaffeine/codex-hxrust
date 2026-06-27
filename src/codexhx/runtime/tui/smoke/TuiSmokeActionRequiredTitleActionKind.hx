package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeActionRequiredTitleActionKind(String) to String {
	final Build = "build";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeActionRequiredTitleActionKind {
		return switch value {
			case "build": Build;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
