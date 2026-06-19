package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalPaletteActionKind(String) to String {
	final ParseOscColor = "parse_osc_color";
	final ParseRgb = "parse_rgb";
	final ParseDefaultColors = "parse_default_colors";
	final Cache = "cache";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalPaletteActionKind {
		return switch value {
			case "parse_osc_color": ParseOscColor;
			case "parse_rgb": ParseRgb;
			case "parse_default_colors": ParseDefaultColors;
			case "cache": Cache;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
