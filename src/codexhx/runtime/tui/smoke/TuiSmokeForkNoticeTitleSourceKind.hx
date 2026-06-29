package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeForkNoticeTitleSourceKind(String) to String {
	final AppServer = "app_server";
	final LocalSessionIndex = "local_session_index";
	final ThreadId = "thread_id";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeForkNoticeTitleSourceKind {
		return switch value {
			case "app_server": AppServer;
			case "local_session_index": LocalSessionIndex;
			case "thread_id": ThreadId;
			case _: Unknown;
		}
	}
}
