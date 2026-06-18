package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeRawModeRestoreKind(String) to String {
	final Disable = "disable";
	final Keep = "keep";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeRawModeRestoreKind {
		return switch value {
			case "disable": Disable;
			case "keep": Keep;
			case "none": None;
			case _: Unknown;
		}
	}
}
