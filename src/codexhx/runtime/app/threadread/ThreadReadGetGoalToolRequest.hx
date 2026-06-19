package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadGetGoalToolRequest {
	public final threadId:String;
	public final argumentsJson:String;
	public final dbOutcomeKind:ThreadReadGetGoalToolDbOutcomeKind;
	public final dbErrorMessage:String;
	public final goal:ThreadGoal;

	public function new(threadId:String, argumentsJson:String, dbOutcomeKind:ThreadReadGetGoalToolDbOutcomeKind, dbErrorMessage:String, goal:ThreadGoal) {
		this.threadId = threadId;
		this.argumentsJson = argumentsJson;
		this.dbOutcomeKind = dbOutcomeKind;
		this.dbErrorMessage = dbErrorMessage;
		this.goal = goal;
	}
}
