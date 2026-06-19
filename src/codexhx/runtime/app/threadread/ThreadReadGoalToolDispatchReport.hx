package codexhx.runtime.app.threadread;

class ThreadReadGoalToolDispatchReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadGoalToolDispatchOutcome>;

	public function new(outcomes:Array<ThreadReadGoalToolDispatchOutcome>) {
		this.schema = "codex-hxrust.thread-read-goal-tool-dispatch-report.v1";
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

	public function eventEmittedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.eventEmitted)
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

	public function specMismatchCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (!outcome.specMatchesDispatch)
				count = count + 1;
		return count;
	}

	public function goalPresentCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.goalPresent)
				count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";success=" + Std.string(successCount()) + ";errors="
			+ Std.string(errorCount()) + ";eventsEmitted=" + Std.string(eventEmittedCount()) + ";completionBudgetReports="
			+ Std.string(completionBudgetReportCount()) + ";specMismatches=" + Std.string(specMismatchCount()) + ";goalPresent="
			+ Std.string(goalPresentCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
