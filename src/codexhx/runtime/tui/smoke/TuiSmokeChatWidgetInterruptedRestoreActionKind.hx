package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetInterruptedRestoreActionKind(String) to String {
	final RecordCancelEditCandidate = "record_cancel_edit_candidate";
	final ArmCancelEdit = "arm_cancel_edit";
	final InterruptedTurn = "interrupted_turn";
	final DrainPendingMessages = "drain_pending_messages";
	final RestoreComposer = "restore_composer";
	final RestoreCancelledTurn = "restore_cancelled_turn";
	final NoticeMode = "notice_mode";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetInterruptedRestoreActionKind {
		return switch value {
			case "record_cancel_edit_candidate": RecordCancelEditCandidate;
			case "arm_cancel_edit": ArmCancelEdit;
			case "interrupted_turn": InterruptedTurn;
			case "drain_pending_messages": DrainPendingMessages;
			case "restore_composer": RestoreComposer;
			case "restore_cancelled_turn": RestoreCancelledTurn;
			case "notice_mode": NoticeMode;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
