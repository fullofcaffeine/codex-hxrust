package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSelectionPopupCommonActionKind(String) to String {
	final MenuSurface = "menu_surface";
	final SingleLine = "single_line";
	final MeasureWrapped = "measure_wrapped";
	final WrapIndent = "wrap_indent";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSelectionPopupCommonActionKind {
		return switch value {
			case "menu_surface": MenuSurface;
			case "single_line": SingleLine;
			case "measure_wrapped": MeasureWrapped;
			case "wrap_indent": WrapIndent;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
