package codexhx.runtime.app.threadread;

class ThreadReadBudgetLimitGoalSteeringReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadBudgetLimitGoalSteeringOutcome>;

	public function new(outcomes:Array<ThreadReadBudgetLimitGoalSteeringOutcome>) {
		this.schema = "codex-hxrust.thread-read-budget-limit-goal-steering-report.v1";
		this.outcomes = outcomes;
	}

	public function injectedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.injected)
				count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.skipped)
				count = count + 1;
		}
		return count;
	}

	public function failureCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.ok)
				count = count + 1;
		}
		return count;
	}

	public function reportMarkedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.reportMarked)
				count = count + 1;
		}
		return count;
	}

	public function duplicateCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.duplicateReportSkipped)
				count = count + 1;
		}
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";injected=" + Std.string(injectedCount()) + ";skipped="
			+ Std.string(skippedCount()) + ";failed=" + Std.string(failureCount()) + ";reportMarked=" + Std.string(reportMarkedCount()) + ";duplicates="
			+ Std.string(duplicateCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
