package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusSurfaceRenderActionKind(String) to String {
	final SelectItems = "select_items";
	final Indicator = "indicator";
	final Warning = "warning";
	final Preview = "preview";
	final Refresh = "refresh";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusSurfaceRenderActionKind {
		return switch value {
			case "select_items": SelectItems;
			case "indicator": Indicator;
			case "warning": Warning;
			case "preview": Preview;
			case "refresh": Refresh;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
