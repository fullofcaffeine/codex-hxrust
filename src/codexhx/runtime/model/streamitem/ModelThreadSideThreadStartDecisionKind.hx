package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadStartDecisionKind(String) to String {
	var StartBlockedMainUnavailable = "start_blocked_main_unavailable";
	var StartBlockedSideOpen = "start_blocked_side_open";
	var ForkFailedNoStartedConversation = "fork_failed_no_started_conversation";
	var ForkFailedGeneric = "fork_failed_generic";
	var InjectFailedCleanup = "inject_failed_cleanup";
	var SwitchFailedCleanup = "switch_failed_cleanup";
	var SwitchedAndSubmittedUserMessage = "switched_and_submitted_user_message";
	var SwitchedWithoutUserMessage = "switched_without_user_message";
	var SwitchedInactiveCleanup = "switched_inactive_cleanup";
}
