package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalStartupProbeActionKind(String) to String {
	final BatchParse = "batch_parse";
	final KeyboardSupport = "keyboard_support";
	final HandleSource = "handle_source";
	final TimeoutFallback = "timeout_fallback";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalStartupProbeActionKind {
		return switch value {
			case "batch_parse": BatchParse;
			case "keyboard_support": KeyboardSupport;
			case "handle_source": HandleSource;
			case "timeout_fallback": TimeoutFallback;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
