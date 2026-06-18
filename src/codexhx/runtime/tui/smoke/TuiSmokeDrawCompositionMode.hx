package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDrawCompositionMode(String) to String {
	final Legacy = "legacy";
	final ResizeReflow = "resize_reflow";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDrawCompositionMode {
		return switch value {
			case "legacy": Legacy;
			case "resize_reflow": ResizeReflow;
			case _: Unknown;
		}
	}
}
