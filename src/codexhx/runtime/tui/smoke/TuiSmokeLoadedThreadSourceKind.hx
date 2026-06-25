package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeLoadedThreadSourceKind(String) to String {
	final Cli = "cli";
	final ThreadSpawn = "thread_spawn";
	final Other = "other";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeLoadedThreadSourceKind {
		return switch value {
			case "cli": Cli;
			case "thread_spawn": ThreadSpawn;
			case "other": Other;
			case _: Unknown;
		}
	}
}
