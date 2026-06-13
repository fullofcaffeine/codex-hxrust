package codexhx.runtime.app.threadread;

enum abstract ThreadReadTurnStatus(String) from String to String {
	var InProgress = "inProgress";
	var Completed = "completed";
	var Interrupted = "interrupted";
	var Failed = "failed";
}
