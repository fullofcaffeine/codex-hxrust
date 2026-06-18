package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadNotificationKind(String) to String {
	final ThreadStatus = "thread_status";
	final AssistantDelta = "assistant_delta";
	final Warning = "warning";
	final ThreadClosed = "thread_closed";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadNotificationKind {
		return switch value {
			case "thread_status": ThreadStatus;
			case "assistant_delta": AssistantDelta;
			case "warning": Warning;
			case "thread_closed": ThreadClosed;
			case _: Unknown;
		}
	}
}
