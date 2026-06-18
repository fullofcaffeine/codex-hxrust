package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeUserInputFocusKind(String) to String {
	final Options = "options";
	final Notes = "notes";
	final Confirmation = "confirmation";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeUserInputFocusKind {
		return switch value {
			case "options": Options;
			case "notes": Notes;
			case "confirmation": Confirmation;
			case "none": None;
			case _: Unknown;
		}
	}
}
