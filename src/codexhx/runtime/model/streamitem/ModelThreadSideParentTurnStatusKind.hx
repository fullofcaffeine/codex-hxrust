package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideParentTurnStatusKind(String) to String {
	var None = "none";
	var Completed = "completed";
	var Interrupted = "interrupted";
	var Failed = "failed";
	var InProgress = "in_progress";
}
