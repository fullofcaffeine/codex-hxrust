package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSelectionPopupColumnMode(String) to String {
	final AutoVisible = "auto_visible";
	final AutoAllRows = "auto_all_rows";
	final Fixed = "fixed";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSelectionPopupColumnMode {
		return switch value {
			case "auto_visible": AutoVisible;
			case "auto_all_rows": AutoAllRows;
			case "fixed": Fixed;
			case _: Unknown;
		}
	}
}
