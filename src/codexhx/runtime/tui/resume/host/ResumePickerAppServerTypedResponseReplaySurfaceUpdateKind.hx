package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind(String) to String {
	final PendingInteractivePrompt = "pending_interactive_prompt";
	final SideParentStatus = "side_parent_status";
	final ActiveThreadStatus = "active_thread_status";
	final Unknown = "unknown";
}
