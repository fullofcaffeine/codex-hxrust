package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusSurfacePreviewActionKind(String) to String {
	final Defaults = "defaults";
	final SetLive = "set_live";
	final SetPlaceholder = "set_placeholder";
	final SuppressPlaceholder = "suppress_placeholder";
	final ValueFor = "value_for";
	final StatusLine = "status_line";
	final RateLimitCopy = "rate_limit_copy";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusSurfacePreviewActionKind {
		return switch value {
			case "defaults": Defaults;
			case "set_live": SetLive;
			case "set_placeholder": SetPlaceholder;
			case "suppress_placeholder": SuppressPlaceholder;
			case "value_for": ValueFor;
			case "status_line": StatusLine;
			case "rate_limit_copy": RateLimitCopy;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
