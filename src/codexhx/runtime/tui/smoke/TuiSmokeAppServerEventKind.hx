package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppServerEventKind(String) to String {
	final ThreadStatus = "thread_status";
	final AssistantDelta = "assistant_delta";
	final Disconnected = "disconnected";
	final StreamClosed = "stream_closed";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerEventKind {
		return switch value {
			case "thread_status": ThreadStatus;
			case "assistant_delta": AssistantDelta;
			case "disconnected": Disconnected;
			case "stream_closed": StreamClosed;
			case _: Unknown;
		}
	}
}
