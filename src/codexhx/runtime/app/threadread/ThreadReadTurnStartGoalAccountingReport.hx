package codexhx.runtime.app.threadread;

class ThreadReadTurnStartGoalAccountingReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTurnStartGoalAccountingOutcome>;

	public function new(outcomes:Array<ThreadReadTurnStartGoalAccountingOutcome>) {
		this.schema = "codex-hxrust.thread-read-turn-start-goal-accounting-report.v1";
		this.outcomes = outcomes;
	}

	public function markedActiveCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.storedGoalMarkedActive) count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.storedGoalMarkedActive) count = count + 1;
		}
		return count;
	}

	public function startTurnCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.startTurnCalled) count = count + 1;
		}
		return count;
	}

	public function planClearedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.clearCurrentTurnGoalCalled) count = count + 1;
		}
		return count;
	}

	public function stateLookupErrorCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.stateLookupError) count = count + 1;
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
			+ ";markedActive=" + Std.string(markedActiveCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";startTurn=" + Std.string(startTurnCount())
			+ ";planCleared=" + Std.string(planClearedCount())
			+ ";stateLookupErrors=" + Std.string(stateLookupErrorCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
