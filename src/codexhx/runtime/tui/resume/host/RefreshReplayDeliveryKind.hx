package codexhx.runtime.tui.resume.host;

enum abstract RefreshReplayDeliveryKind(String) to String {
	final PendingInteractiveReplay = "pending_interactive_replay";
	final SideParentStatus = "side_parent_status";
	final ActiveThreadStatus = "active_thread_status";
	final Unknown = "unknown";
}
