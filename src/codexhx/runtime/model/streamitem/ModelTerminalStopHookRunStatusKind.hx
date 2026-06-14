package codexhx.runtime.model.streamitem;

enum abstract ModelTerminalStopHookRunStatusKind(String) to String {
	final Running = "running";
	final Completed = "completed";
	final Failed = "failed";
	final Blocked = "blocked";
	final Stopped = "stopped";
}
