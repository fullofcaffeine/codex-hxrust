package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetThreadInputStateMode(String) to String {
	final Capture = "capture";
	final RestoreSome = "restore_some";
	final RestoreNone = "restore_none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetThreadInputStateMode {
		return switch value {
			case "capture": Capture;
			case "restore_some": RestoreSome;
			case "restore_none": RestoreNone;
			case _: Unknown;
		}
	}
}
