package codexhx.runtime.model.streamitem;

enum abstract ModelThreadActiveTurnEventKind(String) to String {
	var TurnsRestored = "turns_restored";
	var TurnStarted = "turn_started";
	var TurnCompleted = "turn_completed";
	var ThreadClosed = "thread_closed";
	var ClearActiveTurn = "clear_active_turn";
}
