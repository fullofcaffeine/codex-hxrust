package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTurnRuntimeActionKind(String) to String {
	final TaskRunningState = "task_running_state";
	final TaskStarted = "task_started";
	final RuntimeMetrics = "runtime_metrics";
	final TaskCompleted = "task_completed";
	final CompletionCleanup = "completion_cleanup";
	final FollowUpBoundary = "follow_up_boundary";
	final PlanImplementationPrompt = "plan_implementation_prompt";
	final RateLimitPrompt = "rate_limit_prompt";
	final Notification = "notification";
	final Warning = "warning";
	final FinalizeTurn = "finalize_turn";
	final NonRetryError = "non_retry_error";
	final PlanUpdate = "plan_update";
	final InterruptedMessage = "interrupted_message";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTurnRuntimeActionKind {
		return switch value {
			case "task_running_state": TaskRunningState;
			case "task_started": TaskStarted;
			case "runtime_metrics": RuntimeMetrics;
			case "task_completed": TaskCompleted;
			case "completion_cleanup": CompletionCleanup;
			case "follow_up_boundary": FollowUpBoundary;
			case "plan_implementation_prompt": PlanImplementationPrompt;
			case "rate_limit_prompt": RateLimitPrompt;
			case "notification": Notification;
			case "warning": Warning;
			case "finalize_turn": FinalizeTurn;
			case "non_retry_error": NonRetryError;
			case "plan_update": PlanUpdate;
			case "interrupted_message": InterruptedMessage;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
