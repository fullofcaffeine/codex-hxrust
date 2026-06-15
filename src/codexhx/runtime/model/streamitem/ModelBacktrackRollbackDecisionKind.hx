package codexhx.runtime.model.streamitem;

enum abstract ModelBacktrackRollbackDecisionKind(String) to String {
	final RemoteImageOnlyClearedComposer = "remote_image_only_cleared_composer";
	final RollbackApplied = "rollback_applied";
	final RollbackUnavailable = "rollback_unavailable";
}
