package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotTurnHistoryDecisionKind(String) to String {
	final TurnHistoryReplayedInOrder = "turn_history_replayed_in_order";
	final TurnHistoryReplayBlocked = "turn_history_replay_blocked";
}
