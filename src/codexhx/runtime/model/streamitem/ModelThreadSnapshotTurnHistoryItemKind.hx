package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotTurnHistoryItemKind(String) to String {
	final UserMessage = "user_message";
	final AgentMessage = "agent_message";
	final Other = "other";
}
