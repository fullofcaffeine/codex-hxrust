package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeCommandPopupItemKind(String) to String {
	final Builtin = "builtin";
	final ServiceTier = "service_tier";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeCommandPopupItemKind {
		return switch value {
			case "builtin": Builtin;
			case "service_tier": ServiceTier;
			case _: Unknown;
		}
	}
}
