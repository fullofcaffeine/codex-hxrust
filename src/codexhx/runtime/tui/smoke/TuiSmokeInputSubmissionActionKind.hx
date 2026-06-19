package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeInputSubmissionActionKind(String) to String {
	final TurnStart = "turn_start";
	final TurnFinish = "turn_finish";
	final TurnRestore = "turn_restore";
	final TurnReset = "turn_reset";
	final PreventIdleSleep = "prevent_idle_sleep";
	final BudgetLimited = "budget_limited";
	final ComposerSubmission = "composer_submission";
	final PreSessionQueue = "pre_session_queue";
	final EmptySubmission = "empty_submission";
	final BlockedImageRestore = "blocked_image_restore";
	final ShellEscape = "shell_escape";
	final UserInputAssembly = "user_input_assembly";
	final MentionRouting = "mention_routing";
	final SubmitUserTurn = "submit_user_turn";
	final PendingSteer = "pending_steer";
	final HistoryRender = "history_render";
	final QueueDrain = "queue_drain";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeInputSubmissionActionKind {
		return switch value {
			case "turn_start": TurnStart;
			case "turn_finish": TurnFinish;
			case "turn_restore": TurnRestore;
			case "turn_reset": TurnReset;
			case "prevent_idle_sleep": PreventIdleSleep;
			case "budget_limited": BudgetLimited;
			case "composer_submission": ComposerSubmission;
			case "pre_session_queue": PreSessionQueue;
			case "empty_submission": EmptySubmission;
			case "blocked_image_restore": BlockedImageRestore;
			case "shell_escape": ShellEscape;
			case "user_input_assembly": UserInputAssembly;
			case "mention_routing": MentionRouting;
			case "submit_user_turn": SubmitUserTurn;
			case "pending_steer": PendingSteer;
			case "history_render": HistoryRender;
			case "queue_drain": QueueDrain;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
