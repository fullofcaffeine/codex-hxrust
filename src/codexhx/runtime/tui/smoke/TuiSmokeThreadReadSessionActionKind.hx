package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadReadSessionActionKind(String) to String {
	final Infer = "infer";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadReadSessionActionKind {
		return switch value {
			case "infer": Infer;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
