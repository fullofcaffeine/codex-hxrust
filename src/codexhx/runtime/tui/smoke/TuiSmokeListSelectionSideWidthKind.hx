package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeListSelectionSideWidthKind(String) to String {
	final Disabled = "disabled";
	final Fixed = "fixed";
	final Half = "half";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeListSelectionSideWidthKind {
		return switch value {
			case "disabled": Disabled;
			case "fixed": Fixed;
			case "half": Half;
			case _: Unknown;
		}
	}
}
