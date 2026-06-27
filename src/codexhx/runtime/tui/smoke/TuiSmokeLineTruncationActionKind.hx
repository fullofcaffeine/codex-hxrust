package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeLineTruncationActionKind(String) to String {
	final Width = "width";
	final Truncate = "truncate";
	final Ellipsis = "ellipsis";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeLineTruncationActionKind {
		return switch value {
			case "width": Width;
			case "truncate": Truncate;
			case "ellipsis": Ellipsis;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
