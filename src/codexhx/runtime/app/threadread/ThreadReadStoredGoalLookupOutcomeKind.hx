package codexhx.runtime.app.threadread;

enum abstract ThreadReadStoredGoalLookupOutcomeKind(String) from String to String {
	var Found = "found";
	var Missing = "missing";
	var Error = "error";
}
