package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDesktopNotificationMethodKind(String) to String {
	final Auto = "auto";
	final Osc9 = "osc9";
	final Bel = "bel";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDesktopNotificationMethodKind {
		return switch value {
			case "auto": Auto;
			case "osc9": Osc9;
			case "bel": Bel;
			case _: Unknown;
		}
	}
}
