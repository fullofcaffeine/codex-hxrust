package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeResizeClearKind(String) to String {
	final None = "none";
	final Visible = "visible";
	final ScrollbackAndVisible = "scrollback_and_visible";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeResizeClearKind {
		return switch value {
			case "none": None;
			case "visible": Visible;
			case "scrollback_and_visible": ScrollbackAndVisible;
			case _: Unknown;
		}
	}
}
