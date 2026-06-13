package codexhx.runtime.app.threadread;

class ThreadReadResumeIdleContinuationReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadResumeIdleContinuationOutcome>;

	public function new(outcomes:Array<ThreadReadResumeIdleContinuationOutcome>) {
		this.schema = "codex-hxrust.thread-read-resume-idle-continuation-report.v1";
		this.outcomes = outcomes;
	}

	public function idleHookCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.idleHookEmitted) count = count + 1;
		}
		return count;
	}

	public function continuationRequestCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.goalContinuationRequested) count = count + 1;
		}
		return count;
	}

	public function turnStartedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.turnStarted) count = count + 1;
		}
		return count;
	}

	public function activeGoalClearedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.activeGoalCleared) count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.skipped) count = count + 1;
		}
		return count;
	}

	public function failureCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.ok) count = count + 1;
		}
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";idleHooks=" + Std.string(idleHookCount())
			+ ";continuationRequests=" + Std.string(continuationRequestCount())
			+ ";turnsStarted=" + Std.string(turnStartedCount())
			+ ";activeGoalsCleared=" + Std.string(activeGoalClearedCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";failed=" + Std.string(failureCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
