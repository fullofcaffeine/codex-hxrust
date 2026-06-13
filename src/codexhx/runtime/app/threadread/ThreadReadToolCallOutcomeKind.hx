package codexhx.runtime.app.threadread;

enum abstract ThreadReadToolCallOutcomeKind(String) from String to String {
	var Completed = "completed";
	var Failed = "failed";
	var Blocked = "blocked";
	var Aborted = "aborted";
}
