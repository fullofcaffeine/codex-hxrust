package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeRateLimitActionKind(String) to String {
	final DurationLabel = "duration_label";
	final WarningThreshold = "warning_threshold";
	final SnapshotPreservation = "snapshot_preservation";
	final SeparateLimitEntries = "separate_limit_entries";
	final SwitchPrompt = "switch_prompt";
	final MemberPrompt = "member_prompt";
	final ErrorKind = "error_kind";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeRateLimitActionKind {
		return switch value {
			case "duration_label": DurationLabel;
			case "warning_threshold": WarningThreshold;
			case "snapshot_preservation": SnapshotPreservation;
			case "separate_limit_entries": SeparateLimitEntries;
			case "switch_prompt": SwitchPrompt;
			case "member_prompt": MemberPrompt;
			case "error_kind": ErrorKind;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
