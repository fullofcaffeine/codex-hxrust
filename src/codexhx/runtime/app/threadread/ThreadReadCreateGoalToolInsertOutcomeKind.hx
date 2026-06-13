package codexhx.runtime.app.threadread;

enum abstract ThreadReadCreateGoalToolInsertOutcomeKind(String) to String {
	public var Inserted = "inserted";
	public var UnfinishedGoal = "unfinished_goal";
	public var Error = "error";
}
