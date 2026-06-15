package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotTurnStatusKind(String) to String {
	final Completed = "completed";
	final Failed = "failed";
	final Interrupted = "interrupted";
	final InProgress = "in_progress";
}
