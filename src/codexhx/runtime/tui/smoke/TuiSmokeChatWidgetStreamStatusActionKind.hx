package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetStreamStatusActionKind(String) to String {
	final ReasoningDelta = "reasoning_delta";
	final ReasoningSectionBreak = "reasoning_section_break";
	final ReasoningFinal = "reasoning_final";
	final RestoreReasoningHeader = "restore_reasoning_header";
	final AssistantMessageCompleted = "assistant_message_completed";
	final StreamIdleRestore = "stream_idle_restore";
	final StreamError = "stream_error";
	final RunState = "run_state";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetStreamStatusActionKind {
		return switch value {
			case "reasoning_delta": ReasoningDelta;
			case "reasoning_section_break": ReasoningSectionBreak;
			case "reasoning_final": ReasoningFinal;
			case "restore_reasoning_header": RestoreReasoningHeader;
			case "assistant_message_completed": AssistantMessageCompleted;
			case "stream_idle_restore": StreamIdleRestore;
			case "stream_error": StreamError;
			case "run_state": RunState;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
