package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHookLifecycleActionKind(String) to String {
	final HookStarted = "hook_started";
	final HookCompleted = "hook_completed";
	final FlushCompletedOutput = "flush_completed_output";
	final FinishActiveCell = "finish_active_cell";
	final UpdateDueVisibility = "update_due_visibility";
	final ScheduleTimer = "schedule_timer";
	final HooksListFetch = "hooks_list_fetch";
	final HooksLoaded = "hooks_loaded";
	final OpenHooksBrowser = "open_hooks_browser";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHookLifecycleActionKind {
		return switch value {
			case "hook_started": HookStarted;
			case "hook_completed": HookCompleted;
			case "flush_completed_output": FlushCompletedOutput;
			case "finish_active_cell": FinishActiveCell;
			case "update_due_visibility": UpdateDueVisibility;
			case "schedule_timer": ScheduleTimer;
			case "hooks_list_fetch": HooksListFetch;
			case "hooks_loaded": HooksLoaded;
			case "open_hooks_browser": OpenHooksBrowser;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
