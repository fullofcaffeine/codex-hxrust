package codexhx.runtime.model.streamitem;

enum abstract ModelTurnLifecycleTerminalKind(String) to String {
	final Completed = "completed";
	final CompletedAfterError = "completed_after_error";
	final Aborted = "aborted";
}
