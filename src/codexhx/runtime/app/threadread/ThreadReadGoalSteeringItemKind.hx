package codexhx.runtime.app.threadread;

enum abstract ThreadReadGoalSteeringItemKind(String) from String to String {
	var Continuation = "continuation";
	var ObjectiveUpdated = "objective_updated";
}
