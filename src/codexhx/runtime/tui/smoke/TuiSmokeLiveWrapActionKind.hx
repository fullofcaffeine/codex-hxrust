package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeLiveWrapActionKind(String) to String {
	final Reset = "reset";
	final Push = "push";
	final EndLine = "end_line";
	final Rows = "rows";
	final Display = "display";
	final SetWidth = "set_width";
	final Drain = "drain";
	final Prefix = "prefix";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeLiveWrapActionKind {
		return switch value {
			case "reset": Reset;
			case "push": Push;
			case "end_line": EndLine;
			case "rows": Rows;
			case "display": Display;
			case "set_width": SetWidth;
			case "drain": Drain;
			case "prefix": Prefix;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
