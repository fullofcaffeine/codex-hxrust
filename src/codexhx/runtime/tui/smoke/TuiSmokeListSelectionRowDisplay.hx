package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeListSelectionRowDisplay(String) to String {
	final Wrapped = "wrapped";
	final SingleLine = "single_line";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeListSelectionRowDisplay {
		return switch value {
			case "wrapped": Wrapped;
			case "single_line": SingleLine;
			case _: Unknown;
		}
	}
}
