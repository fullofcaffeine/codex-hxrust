package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeEventStreamPollOrder(String) to String {
	final InputFirst = "input_first";
	final DrawFirst = "draw_first";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeEventStreamPollOrder {
		return switch value {
			case "input_first": InputFirst;
			case "draw_first": DrawFirst;
			case _: Unknown;
		}
	}
}
