package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadComposerHandoffDecisionKind(String) to String {
	var NoUserMessageNoop = "no_user_message_noop";
	var RestoredAfterStartBlocked = "restored_after_start_blocked";
	var RestoredAfterForkFailure = "restored_after_fork_failure";
	var RestoredAfterPrepareFailure = "restored_after_prepare_failure";
	var RestoredAfterSwitchFailure = "restored_after_switch_failure";
	var RestoredAfterInactiveChildCleanup = "restored_after_inactive_child_cleanup";
	var SubmittedAfterSwitch = "submitted_after_switch";
}
