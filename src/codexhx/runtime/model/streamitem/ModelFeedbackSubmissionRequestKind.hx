package codexhx.runtime.model.streamitem;

enum abstract ModelFeedbackSubmissionRequestKind(String) from String to String {
	final Submitted = "submitted";
	final SnapshotReplay = "snapshot_replay";
}
