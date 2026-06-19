package codexhx.runtime.tui.turn;

enum abstract TurnRuntimeStatus(String) from String to String {
	var Idle = "idle";
	var Running = "running";
	var Completed = "completed";
	var Failed = "failed";
	var Cancelled = "cancelled";
}
