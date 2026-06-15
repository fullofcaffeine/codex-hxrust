package codexhx.runtime.model.streamitem;

enum abstract ModelQueuedRollbackOverlaySyncDecisionKind(String) to String {
	final RollbackApplied = "rollback_applied";
	final RollbackUnchanged = "rollback_unchanged";
}
