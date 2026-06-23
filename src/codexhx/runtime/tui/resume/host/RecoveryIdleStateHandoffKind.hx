package codexhx.runtime.tui.resume.host;

enum abstract RecoveryIdleStateHandoffKind(String) to String {
	final IdleListReady = "idle_list_ready";
	final HandoffRejected = "handoff_rejected";
	final Unknown = "unknown";
}
