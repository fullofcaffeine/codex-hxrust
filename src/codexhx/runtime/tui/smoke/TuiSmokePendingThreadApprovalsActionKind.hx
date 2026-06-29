package codexhx.runtime.tui.smoke;

enum abstract TuiSmokePendingThreadApprovalsActionKind(String) to String {
	final SetThreads = "set_threads";
	final Render = "render";
	final ClearAfterTurnCompletion = "clear_after_turn_completion";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokePendingThreadApprovalsActionKind {
		return switch value {
			case "set_threads": SetThreads;
			case "render": Render;
			case "clear_after_turn_completion": ClearAfterTurnCompletion;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
