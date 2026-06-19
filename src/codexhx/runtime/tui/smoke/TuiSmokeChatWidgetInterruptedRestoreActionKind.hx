package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetInterruptedRestoreActionKind(String) to String {
	final RecordCancelEditCandidate = "record_cancel_edit_candidate";
	final RecordVisibleTurnActivity = "record_visible_turn_activity";
	final ArmCancelEdit = "arm_cancel_edit";
	final TakeCancelEdit = "take_cancel_edit";
	final ClearCancelEdit = "clear_cancel_edit";
	final InitialUserMessage = "initial_user_message";
	final InterruptedTurn = "interrupted_turn";
	final QueuePopNext = "queue_pop_next";
	final QueuePopLatest = "queue_pop_latest";
	final EnqueueRejectedSteer = "enqueue_rejected_steer";
	final CaptureThreadInputState = "capture_thread_input_state";
	final RestoreThreadInputState = "restore_thread_input_state";
	final DrainPendingMessages = "drain_pending_messages";
	final RestoreComposer = "restore_composer";
	final RestoreMessageShape = "restore_message_shape";
	final RestoreCancelledTurn = "restore_cancelled_turn";
	final NoticeMode = "notice_mode";
	final QueueAutosend = "queue_autosend";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetInterruptedRestoreActionKind {
		return switch value {
			case "record_cancel_edit_candidate": RecordCancelEditCandidate;
			case "record_visible_turn_activity": RecordVisibleTurnActivity;
			case "arm_cancel_edit": ArmCancelEdit;
			case "take_cancel_edit": TakeCancelEdit;
			case "clear_cancel_edit": ClearCancelEdit;
			case "initial_user_message": InitialUserMessage;
			case "interrupted_turn": InterruptedTurn;
			case "queue_pop_next": QueuePopNext;
			case "queue_pop_latest": QueuePopLatest;
			case "enqueue_rejected_steer": EnqueueRejectedSteer;
			case "capture_thread_input_state": CaptureThreadInputState;
			case "restore_thread_input_state": RestoreThreadInputState;
			case "drain_pending_messages": DrainPendingMessages;
			case "restore_composer": RestoreComposer;
			case "restore_message_shape": RestoreMessageShape;
			case "restore_cancelled_turn": RestoreCancelledTurn;
			case "notice_mode": NoticeMode;
			case "queue_autosend": QueueAutosend;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
