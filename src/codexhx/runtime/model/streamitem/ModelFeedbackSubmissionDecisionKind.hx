package codexhx.runtime.model.streamitem;

enum abstract ModelFeedbackSubmissionDecisionKind(String) from String to String {
	final CurrentHistoryRendered = "current_history_rendered";
	final OriginThreadBuffered = "origin_thread_buffered";
	final ActiveOriginThreadDelivered = "active_origin_thread_delivered";
	final SnapshotReplayRendered = "snapshot_replay_rendered";
}
