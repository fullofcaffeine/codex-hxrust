package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeExitMode(String) to String {
	final ShutdownFirst = "shutdown_first";
	final Immediate = "immediate";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeExitMode {
		return switch value {
			case "shutdown_first": ShutdownFirst;
			case "immediate": Immediate;
			case _: Unknown;
		}
	}
}
