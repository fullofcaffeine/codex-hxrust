package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadStartedSessionActionKind(String) to String {
	final Initialize = "initialize";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadStartedSessionActionKind {
		return switch value {
			case "initialize": Initialize;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
