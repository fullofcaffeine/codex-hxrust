package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadDiscardDecisionKind(String) to String {
	var ReturnedFromSide = "returned_from_side";
	var ReturnBlocked = "return_blocked";
	var ReturnSelectionFailed = "return_selection_failed";
	var NoDiscardSameTarget = "no_discard_same_target";
	var NoDiscardNoSideThread = "no_discard_no_side_thread";
	var DiscardedActiveTurn = "discarded_active_turn";
	var DiscardedStartup = "discarded_startup";
	var DiscardFailedInterrupt = "discard_failed_interrupt";
	var DiscardFailedUnsubscribe = "discard_failed_unsubscribe";
	var DiscardedClosedLocalState = "discarded_closed_local_state";
}
