package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppThreadInputHandoffMode(String) to String {
	final StoreActive = "store_active";
	final RestoreSnapshot = "restore_snapshot";
	final MissingSnapshotFallback = "missing_snapshot_fallback";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppThreadInputHandoffMode {
		return switch value {
			case "store_active": StoreActive;
			case "restore_snapshot": RestoreSnapshot;
			case "missing_snapshot_fallback": MissingSnapshotFallback;
			case _: Unknown;
		}
	}
}
