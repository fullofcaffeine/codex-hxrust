package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadReplayActionKind(String) to String {
	final SnapshotActive = "snapshot_active";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadReplayActionKind {
		return switch value {
			case "snapshot_active": SnapshotActive;
			case _: Unknown;
		}
	}
}
