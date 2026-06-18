package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalMode(String) to String {
	final Headless = "headless";
	final NativePlaceholder = "native_placeholder";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalMode {
		return switch value {
			case "headless": Headless;
			case "native_placeholder": NativePlaceholder;
			case _: Unknown;
		}
	}
}
