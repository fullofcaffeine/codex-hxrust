package codexhx.runtime.app.threadread;

class ThreadReadUpdateGoalToolReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadUpdateGoalToolOutcome>;

	public function new(outcomes:Array<ThreadReadUpdateGoalToolOutcome>) {
		this.schema = "codex-hxrust.thread-read-update-goal-tool-report.v1";
		this.outcomes = outcomes;
	}

	public function successCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.ok)
				count = count + 1;
		return count;
	}

	public function errorCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (!outcome.ok)
				count = count + 1;
		return count;
	}

	public function completionBudgetReportCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.hasCompletionBudgetReport)
				count = count + 1;
		return count;
	}

	public function eventEmittedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.eventEmitted)
				count = count + 1;
		return count;
	}

	public function accountingAttemptedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.accountingAttempted)
				count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";success=" + Std.string(successCount()) + ";errors="
			+ Std.string(errorCount()) + ";completionBudgetReports=" + Std.string(completionBudgetReportCount()) + ";eventsEmitted="
			+ Std.string(eventEmittedCount()) + ";accountingAttempted=" + Std.string(accountingAttemptedCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
