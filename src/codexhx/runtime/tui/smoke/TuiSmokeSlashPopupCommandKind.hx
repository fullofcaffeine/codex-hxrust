package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSlashPopupCommandKind(String) to String {
	final Builtin = "builtin";
	final ServiceTier = "service_tier";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSlashPopupCommandKind {
		return switch value {
			case "builtin": Builtin;
			case "service_tier": ServiceTier;
			case _: Unknown;
		}
	}
}
