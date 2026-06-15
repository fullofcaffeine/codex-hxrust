package codexhx.runtime.model.streamitem;

enum abstract ModelCollabReplayWaitStatusKind(String) to String {
	final InProgress = "in_progress";
	final Completed = "completed";
	final Failed = "failed";
}
