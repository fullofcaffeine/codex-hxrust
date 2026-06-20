package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffKind(String) to String {
	final IdleListReady = "idle_list_ready";
	final HandoffRejected = "handoff_rejected";
	final Unknown = "unknown";
}
