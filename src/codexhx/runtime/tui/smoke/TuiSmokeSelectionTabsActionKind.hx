package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSelectionTabsActionKind(String) to String {
	final Lines = "lines";
	final Height = "height";
	final Render = "render";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSelectionTabsActionKind {
		return switch value {
			case "lines": Lines;
			case "height": Height;
			case "render": Render;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
