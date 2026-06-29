package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget app-server lifecycle notifications. */
enum abstract TuiSmokeAppServerLifecycleActionKind(String) to String {
	final ThreadClosedImmediateExit = "thread_closed_immediate_exit";
	final ThreadNameInvalidIgnored = "thread_name_invalid_ignored";
	final ThreadNameResumeHint = "thread_name_resume_hint";
	final ReplaySuppressed = "replay_suppressed";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerLifecycleActionKind {
		return switch value {
			case "thread_closed_immediate_exit": ThreadClosedImmediateExit;
			case "thread_name_invalid_ignored": ThreadNameInvalidIgnored;
			case "thread_name_resume_hint": ThreadNameResumeHint;
			case "replay_suppressed": ReplaySuppressed;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
