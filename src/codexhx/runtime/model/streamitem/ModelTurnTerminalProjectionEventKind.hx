package codexhx.runtime.model.streamitem;

enum abstract ModelTurnTerminalProjectionEventKind(String) to String {
	final TurnComplete = "turn_complete";
	final TurnAborted = "turn_aborted";
}
