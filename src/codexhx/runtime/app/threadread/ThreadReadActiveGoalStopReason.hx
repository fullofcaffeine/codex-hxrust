package codexhx.runtime.app.threadread;

enum abstract ThreadReadActiveGoalStopReason(String) from String to String {
	var TurnError = "turn_error";
	var UsageLimit = "usage_limit";
}
