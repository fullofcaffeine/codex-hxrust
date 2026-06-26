package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeGoalDisplayActionKind(String) to String {
	final Elapsed = "elapsed";
	final StatusLabel = "status_label";
	final UsageSummary = "usage_summary";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeGoalDisplayActionKind {
		return switch value {
			case "elapsed": Elapsed;
			case "status_label": StatusLabel;
			case "usage_summary": UsageSummary;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
