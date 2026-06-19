package codexhx.runtime.tui.turn;

enum abstract TurnTerminalReason(String) from String to String {
	var None = "none";
	var Completed = "completed";
	var Failed = "failed";
	var Cancelled = "cancelled";
}
