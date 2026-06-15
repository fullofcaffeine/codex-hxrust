package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadStartFailureKind(String) to String {
	var None = "none";
	var MainThreadUnavailable = "main_thread_unavailable";
	var SideAlreadyOpen = "side_already_open";
	var ForkNoStartedConversation = "fork_no_started_conversation";
	var ForkGeneric = "fork_generic";
	var InjectBoundary = "inject_boundary";
	var SwitchFailed = "switch_failed";
	var ActiveChildMissing = "active_child_missing";
}
