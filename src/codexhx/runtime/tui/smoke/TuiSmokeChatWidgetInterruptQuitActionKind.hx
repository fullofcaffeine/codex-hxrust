package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetInterruptQuitActionKind(String) to String {
	final CtrlC = "ctrl_c";
	final CtrlCPrecedence = "ctrl_c_precedence";
	final CtrlD = "ctrl_d";
	final InterruptKey = "interrupt_key";
	final ArmQuitShortcut = "arm_quit_shortcut";
	final ShortcutState = "shortcut_state";
	final RequestQuit = "request_quit";
	final ShutdownFeedback = "shutdown_feedback";
	final PrepareInterruptSubmission = "prepare_interrupt_submission";
	final CancelEditCleanup = "cancel_edit_cleanup";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetInterruptQuitActionKind {
		return switch value {
			case "ctrl_c": CtrlC;
			case "ctrl_c_precedence": CtrlCPrecedence;
			case "ctrl_d": CtrlD;
			case "interrupt_key": InterruptKey;
			case "arm_quit_shortcut": ArmQuitShortcut;
			case "shortcut_state": ShortcutState;
			case "request_quit": RequestQuit;
			case "shutdown_feedback": ShutdownFeedback;
			case "prepare_interrupt_submission": PrepareInterruptSubmission;
			case "cancel_edit_cleanup": CancelEditCleanup;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
