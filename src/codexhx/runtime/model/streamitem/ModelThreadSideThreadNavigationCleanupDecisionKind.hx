package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadNavigationCleanupDecisionKind(String) to String {
	var NoDiscardSameTarget = "no_discard_same_target";
	var NoDiscardNoVisibleSideThread = "no_discard_no_visible_side_thread";
	var DiscardedServerClosed = "discarded_server_closed";
	var KeptLocalStateInterruptFailed = "kept_local_state_interrupt_failed";
	var KeptLocalStateUnsubscribeFailed = "kept_local_state_unsubscribe_failed";
	var DiscardedClosedLocalStateOnly = "discarded_closed_local_state_only";
	var SelectedParentAndDiscarded = "selected_parent_and_discarded";
	var SelectedParentCleanupFailedKeptVisible = "selected_parent_cleanup_failed_kept_visible";
}
