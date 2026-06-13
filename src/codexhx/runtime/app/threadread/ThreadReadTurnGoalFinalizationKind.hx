package codexhx.runtime.app.threadread;

enum abstract ThreadReadTurnGoalFinalizationKind(String) from String to String {
	var TurnStop = "turn_stop";
	var TurnAbort = "turn_abort";
}
