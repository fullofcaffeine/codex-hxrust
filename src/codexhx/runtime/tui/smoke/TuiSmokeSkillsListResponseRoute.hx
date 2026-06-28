package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSkillsListResponseRoute(String) to String {
	final CwdNewWarnings = "cwd_new_warnings";
	final DuplicateSuppressed = "duplicate_suppressed";
	final ClearedReemitted = "cleared_reemitted";
	final CwdMissingNoErrors = "cwd_missing_no_errors";
	final LiveBoundaryRejected = "live_boundary_rejected";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSkillsListResponseRoute {
		return switch value {
			case "cwd_new_warnings": CwdNewWarnings;
			case "duplicate_suppressed": DuplicateSuppressed;
			case "cleared_reemitted": ClearedReemitted;
			case "cwd_missing_no_errors": CwdMissingNoErrors;
			case "live_boundary_rejected": LiveBoundaryRejected;
			case _: Unknown;
		}
	}
}
