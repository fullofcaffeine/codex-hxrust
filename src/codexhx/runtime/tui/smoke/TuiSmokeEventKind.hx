package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeEventKind(String) to String {
	final Draw = "draw";
	final Resize = "resize";
	final Key = "key";
	final StatusUpdate = "status_update";
	final InputUpdate = "input_update";
	final AppExit = "app_exit";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeEventKind {
		return switch value {
			case "draw": Draw;
			case "resize": Resize;
			case "key": Key;
			case "status_update": StatusUpdate;
			case "input_update": InputUpdate;
			case "app_exit": AppExit;
			case _: Unknown;
		}
	}
}
