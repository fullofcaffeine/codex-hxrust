package codexhx.runtime.model.streamitem;

enum abstract ModelTurnTerminalProjectedStatusKind(String) to String {
	final Completed = "completed";
	final Interrupted = "interrupted";
	final Failed = "failed";
	final Errored = "errored";
}
