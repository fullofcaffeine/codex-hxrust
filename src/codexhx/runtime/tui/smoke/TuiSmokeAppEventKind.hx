package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppEventKind(String) to String {
	final StartupStatus = "startup_status";
	final CommitTick = "commit_tick";
	final Exit = "exit";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppEventKind {
		return switch value {
			case "startup_status": StartupStatus;
			case "commit_tick": CommitTick;
			case "exit": Exit;
			case _: Unknown;
		}
	}
}
