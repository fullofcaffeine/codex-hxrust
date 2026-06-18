package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDrawDispatchEventKind(String) to String {
	final Draw = "draw";
	final Resize = "resize";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDrawDispatchEventKind {
		return switch value {
			case "draw": Draw;
			case "resize": Resize;
			case _: Unknown;
		}
	}
}
