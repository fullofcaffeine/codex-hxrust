package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeBacktrackOverlayActionKind(String) to String {
	final Prime = "prime";
	final OpenPreview = "open_preview";
	final OverlayPreview = "overlay_preview";
	final Step = "step";
	final Selection = "selection";
	final Confirm = "confirm";
	final RollbackRequest = "rollback_request";
	final RollbackSuccess = "rollback_success";
	final RollbackFailure = "rollback_failure";
	final NonPendingRollback = "non_pending_rollback";
	final Trim = "trim";
	final Unavailable = "unavailable";
	final Reset = "reset";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeBacktrackOverlayActionKind {
		return switch value {
			case "prime": Prime;
			case "open_preview": OpenPreview;
			case "overlay_preview": OverlayPreview;
			case "step": Step;
			case "selection": Selection;
			case "confirm": Confirm;
			case "rollback_request": RollbackRequest;
			case "rollback_success": RollbackSuccess;
			case "rollback_failure": RollbackFailure;
			case "non_pending_rollback": NonPendingRollback;
			case "trim": Trim;
			case "unavailable": Unavailable;
			case "reset": Reset;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
