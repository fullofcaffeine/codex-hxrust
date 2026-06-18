package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetStreamLifecycleActionKind(String) to String {
	final StreamingDelta = "streaming_delta";
	final DeferOrHandle = "defer_or_handle";
	final FlushInterruptQueue = "flush_interrupt_queue";
	final StreamFinished = "stream_finished";
	final TaskComplete = "task_complete";
	final FinalizeTurn = "finalize_turn";
	final StopCommitAnimation = "stop_commit_animation";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetStreamLifecycleActionKind {
		return switch value {
			case "streaming_delta": StreamingDelta;
			case "defer_or_handle": DeferOrHandle;
			case "flush_interrupt_queue": FlushInterruptQueue;
			case "stream_finished": StreamFinished;
			case "task_complete": TaskComplete;
			case "finalize_turn": FinalizeTurn;
			case "stop_commit_animation": StopCommitAnimation;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
