package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadCreateGoalToolResponse {
	public final goal:ThreadGoal;
	public final hasRemainingTokens:Bool;
	public final remainingTokens:Int;
	public final hasCompletionBudgetReport:Bool;
	public final completionBudgetReport:String;

	public function new(goal:ThreadGoal, hasRemainingTokens:Bool, remainingTokens:Int) {
		this.goal = goal;
		this.hasRemainingTokens = hasRemainingTokens;
		this.remainingTokens = remainingTokens;
		this.hasCompletionBudgetReport = false;
		this.completionBudgetReport = "";
	}

	public static function fromGoal(goal:ThreadGoal):ThreadReadCreateGoalToolResponse {
		final remaining = goal.remainingTokens();
		return new ThreadReadCreateGoalToolResponse(goal, remaining.present, remaining.value);
	}

	public function summary():String {
		return "goalPresent=" + boolText(goal != null)
			+ ";remainingTokens=" + (hasRemainingTokens ? Std.string(remainingTokens) : "null")
			+ ";completionBudgetReport=" + (hasCompletionBudgetReport ? completionBudgetReport : "null");
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
