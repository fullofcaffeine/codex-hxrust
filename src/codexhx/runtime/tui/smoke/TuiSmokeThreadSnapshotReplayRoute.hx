package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadSnapshotReplayRoute(String) to String {
	final Normal = "normal";
	final QuietPendingInteractive = "quiet_pending_interactive";
	final SideThread = "side_thread";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadSnapshotReplayRoute {
		return switch value {
			case "normal": Normal;
			case "quiet_pending_interactive": QuietPendingInteractive;
			case "side_thread": SideThread;
			case _: Unknown;
		}
	}
}
