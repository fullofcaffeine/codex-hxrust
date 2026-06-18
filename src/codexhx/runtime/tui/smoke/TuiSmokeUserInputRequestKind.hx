package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeUserInputRequestKind(String) to String {
	final Options = "options";
	final Freeform = "freeform";
	final Mixed = "mixed";
	final Secret = "secret";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeUserInputRequestKind {
		return switch value {
			case "options": Options;
			case "freeform": Freeform;
			case "mixed": Mixed;
			case "secret": Secret;
			case _: Unknown;
		}
	}
}
