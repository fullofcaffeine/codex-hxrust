package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusStateActionKind(String) to String {
	final DefaultState = "default_state";
	final SetStatus = "set_status";
	final GuardianStartOrUpdate = "guardian_start_or_update";
	final GuardianFinish = "guardian_finish";
	final RetryHeaderRemember = "retry_header_remember";
	final RetryHeaderTake = "retry_header_take";
	final TerminalTitleStatusKind = "terminal_title_status_kind";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusStateActionKind {
		return switch value {
			case "default_state": DefaultState;
			case "set_status": SetStatus;
			case "guardian_start_or_update": GuardianStartOrUpdate;
			case "guardian_finish": GuardianFinish;
			case "retry_header_remember": RetryHeaderRemember;
			case "retry_header_take": RetryHeaderTake;
			case "terminal_title_status_kind": TerminalTitleStatusKind;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
