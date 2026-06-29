package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget model safety-buffering behavior. */
enum abstract TuiSmokeSafetyBufferingActionKind(String) to String {
	final RetryPrompt = "retry_prompt";
	final RetryConfirmed = "retry_confirmed";
	final AgentMessageStarted = "agent_message_started";
	final NoRetryStatus = "no_retry_status";
	final IgnoredUpdate = "ignored_update";
	final HiddenClear = "hidden_clear";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSafetyBufferingActionKind {
		return switch value {
			case "retry_prompt": RetryPrompt;
			case "retry_confirmed": RetryConfirmed;
			case "agent_message_started": AgentMessageStarted;
			case "no_retry_status": NoRetryStatus;
			case "ignored_update": IgnoredUpdate;
			case "hidden_clear": HiddenClear;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
