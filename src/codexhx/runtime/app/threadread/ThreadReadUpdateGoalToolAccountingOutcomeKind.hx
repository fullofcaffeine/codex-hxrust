package codexhx.runtime.app.threadread;

enum abstract ThreadReadUpdateGoalToolAccountingOutcomeKind(String) to String {
	public var NoCurrentTurn = "no_current_turn";
	public var NoSnapshot = "no_snapshot";
	public var Updated = "updated";
	public var Unchanged = "unchanged";
	public var Error = "error";
}
