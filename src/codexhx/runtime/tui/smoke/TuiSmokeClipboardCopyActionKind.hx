package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeClipboardCopyActionKind(String) to String {
	final Route = "route";
	final Osc52Sequence = "osc52_sequence";
	final TmuxReady = "tmux_ready";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeClipboardCopyActionKind {
		return switch value {
			case "route": Route;
			case "osc52_sequence": Osc52Sequence;
			case "tmux_ready": TmuxReady;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
