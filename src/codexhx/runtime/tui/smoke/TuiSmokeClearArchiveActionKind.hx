package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeClearArchiveActionKind(String) to String {
	final ClearTerminalUi = "clear_terminal_ui";
	final ResetUiState = "reset_ui_state";
	final QueueClearHeader = "queue_clear_header";
	final StartFreshSession = "start_fresh_session";
	final SkillWarnings = "skill_warnings";
	final ArchiveRequest = "archive_request";
	final ArchiveResult = "archive_result";
	final ShutdownFeedback = "shutdown_feedback";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeClearArchiveActionKind {
		return switch value {
			case "clear_terminal_ui": ClearTerminalUi;
			case "reset_ui_state": ResetUiState;
			case "queue_clear_header": QueueClearHeader;
			case "start_fresh_session": StartFreshSession;
			case "skill_warnings": SkillWarnings;
			case "archive_request": ArchiveRequest;
			case "archive_result": ArchiveResult;
			case "shutdown_feedback": ShutdownFeedback;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
