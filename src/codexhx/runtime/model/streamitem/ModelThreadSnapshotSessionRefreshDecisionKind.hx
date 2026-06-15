package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotSessionRefreshDecisionKind(String) to String {
	final RefreshedSnapshotPersisted = "refreshed_snapshot_persisted";
	final RefreshedSnapshotBlocked = "refreshed_snapshot_blocked";
}
