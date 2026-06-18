package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDesktopNotificationConditionKind(String) to String {
	final Unfocused = "unfocused";
	final Always = "always";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDesktopNotificationConditionKind {
		return switch value {
			case "unfocused": Unfocused;
			case "always": Always;
			case _: Unknown;
		}
	}
}
