package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadTurnStatus(String) to String {
	final InProgress = "in_progress";
	final Completed = "completed";
	final Interrupted = "interrupted";
	final Failed = "failed";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadTurnStatus {
		return switch value {
			case "in_progress": InProgress;
			case "completed": Completed;
			case "interrupted": Interrupted;
			case "failed": Failed;
			case _: Unknown;
		}
	}
}
