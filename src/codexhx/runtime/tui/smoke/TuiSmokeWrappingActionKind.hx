package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeWrappingActionKind(String) to String {
	final ContainsUrl = "contains_url";
	final LineContainsUrl = "line_contains_url";
	final Mixed = "mixed";
	final AdaptiveWrap = "adaptive_wrap";
	final RangeTrim = "range_trim";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeWrappingActionKind {
		return switch value {
			case "contains_url": ContainsUrl;
			case "line_contains_url": LineContainsUrl;
			case "mixed": Mixed;
			case "adaptive_wrap": AdaptiveWrap;
			case "range_trim": RangeTrim;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
