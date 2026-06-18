package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppLinkScreenKind(String) to String {
	final Link = "link";
	final Confirmation = "confirmation";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppLinkScreenKind {
		return switch value {
			case "link": Link;
			case "confirmation": Confirmation;
			case _: Unknown;
		}
	}
}
