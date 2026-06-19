package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeCommandLifecycleActionKind(String) to String {
	final ProcessBegin = "process_begin";
	final OutputChunk = "output_chunk";
	final ProcessEnd = "process_end";
	final CommandStarted = "command_started";
	final TerminalInteraction = "terminal_interaction";
	final CommandCompleted = "command_completed";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeCommandLifecycleActionKind {
		return switch value {
			case "process_begin": ProcessBegin;
			case "output_chunk": OutputChunk;
			case "process_end": ProcessEnd;
			case "command_started": CommandStarted;
			case "terminal_interaction": TerminalInteraction;
			case "command_completed": CommandCompleted;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
