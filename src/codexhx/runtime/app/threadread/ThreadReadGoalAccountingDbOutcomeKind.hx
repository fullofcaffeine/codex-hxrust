package codexhx.runtime.app.threadread;

enum abstract ThreadReadGoalAccountingDbOutcomeKind(String) from String to String {
	var Updated = "updated";
	var Unchanged = "unchanged";
	var Error = "error";
}
