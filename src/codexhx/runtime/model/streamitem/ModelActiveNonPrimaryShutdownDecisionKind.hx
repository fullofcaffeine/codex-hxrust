package codexhx.runtime.model.streamitem;

enum abstract ModelActiveNonPrimaryShutdownDecisionKind(String) to String {
	var IgnoredNonShutdownEvent = "ignored_non_shutdown_event";
	var IgnoredMissingThreadIds = "ignored_missing_thread_ids";
	var IgnoredPrimaryThreadShutdown = "ignored_primary_thread_shutdown";
	var IgnoredPendingShutdownExit = "ignored_pending_shutdown_exit";
	var SwitchedToPrimary = "switched_to_primary";
	var SwitchedToPrimaryWithOtherPendingExit = "switched_to_primary_with_other_pending_exit";
}
