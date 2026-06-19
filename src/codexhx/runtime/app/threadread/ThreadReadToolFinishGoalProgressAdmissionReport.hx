package codexhx.runtime.app.threadread;

class ThreadReadToolFinishGoalProgressAdmissionReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadToolFinishGoalProgressAdmissionOutcome>;

	public function new(outcomes:Array<ThreadReadToolFinishGoalProgressAdmissionOutcome>) {
		this.schema = "codex-hxrust.thread-read-tool-finish-goal-progress-admission-report.v1";
		this.outcomes = outcomes;
	}

	public function admittedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.admitted)
				count = count + 1;
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (!outcome.admitted)
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

	public function warningCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.warningLogged)
				count = count + 1;
		return count;
	}

	public function budgetLimitedProgressCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.budgetLimitedProgress)
				count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";admitted=" + Std.string(admittedCount()) + ";skipped="
			+ Std.string(skippedCount()) + ";accountingAttempted=" + Std.string(accountingAttemptedCount()) + ";warnings=" + Std.string(warningCount())
			+ ";budgetLimitedProgress=" + Std.string(budgetLimitedProgressCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
