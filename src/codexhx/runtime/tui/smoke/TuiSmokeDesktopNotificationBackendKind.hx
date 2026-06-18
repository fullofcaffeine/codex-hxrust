package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDesktopNotificationBackendKind(String) to String {
	final Osc9 = "osc9";
	final Bel = "bel";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDesktopNotificationBackendKind {
		return switch value {
			case "osc9": Osc9;
			case "bel": Bel;
			case "none": None;
			case _: Unknown;
		}
	}
}
