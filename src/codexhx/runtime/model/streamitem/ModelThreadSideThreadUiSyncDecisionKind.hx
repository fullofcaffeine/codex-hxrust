package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadUiSyncDecisionKind(String) to String {
	var ClearedNoActiveThread = "cleared_no_active_thread";
	var ClearedNoSideThread = "cleared_no_side_thread";
	var SyncedChangedStatus = "synced_changed_status";
	var SkippedSameStatus = "skipped_same_status";
}
