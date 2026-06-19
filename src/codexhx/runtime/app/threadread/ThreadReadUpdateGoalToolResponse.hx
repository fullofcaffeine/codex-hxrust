package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadUpdateGoalToolResponse {
	public static inline final completionBudgetReportText = "Goal achieved. Report final usage from this tool result's structured goal fields. If `goal.tokenBudget` is present, include token usage from `goal.tokensUsed` and `goal.tokenBudget`. If `goal.timeUsedSeconds` is greater than 0, summarize elapsed time in a concise, human-friendly form appropriate to the response language.";

	public final goal:ThreadGoal;
	public final hasRemainingTokens:Bool;
	public final remainingTokens:Int;
	public final hasCompletionBudgetReport:Bool;
	public final completionBudgetReport:String;

	public function new(goal:ThreadGoal, hasRemainingTokens:Bool, remainingTokens:Int, hasCompletionBudgetReport:Bool) {
		this.goal = goal;
		this.hasRemainingTokens = hasRemainingTokens;
		this.remainingTokens = remainingTokens;
		this.hasCompletionBudgetReport = hasCompletionBudgetReport;
		this.completionBudgetReport = hasCompletionBudgetReport ? completionBudgetReportText : "";
	}

	public static function fromGoal(goal:ThreadGoal, includeCompletionBudgetReport:Bool):ThreadReadUpdateGoalToolResponse {
		final remaining = goal.remainingTokens();
		final includeReport = includeCompletionBudgetReport
			&& goal.status == ThreadGoalStatus.Complete
			&& (goal.hasTokenBudget || goal.timeUsedSeconds > 0);
		return new ThreadReadUpdateGoalToolResponse(goal, remaining.present, remaining.value, includeReport);
	}

	public function summary():String {
		return "goalPresent="
			+ boolText(goal != null)
			+ ";remainingTokens="
			+ (hasRemainingTokens ? Std.string(remainingTokens) : "null")
			+ ";completionBudgetReport="
			+ boolText(hasCompletionBudgetReport);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
