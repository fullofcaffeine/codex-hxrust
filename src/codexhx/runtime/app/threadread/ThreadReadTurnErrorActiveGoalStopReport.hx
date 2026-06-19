package codexhx.runtime.app.threadread;

class ThreadReadTurnErrorActiveGoalStopReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTurnErrorActiveGoalStopOutcome>;

	public function new(outcomes:Array<ThreadReadTurnErrorActiveGoalStopOutcome>) {
		this.schema = "codex-hxrust.thread-read-turn-error-active-goal-stop-report.v1";
		this.outcomes = outcomes;
	}

	public function stoppedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.statusUpdated)
				count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.goalStatePermitAttempted && !outcome.accountingAttempted)
				count = count + 1;
		}
		return count;
	}

	public function noOpCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.goalStatePermitOk && !outcome.statusUpdated && !outcome.warningLogged && outcome.runtimeEnabled)
				count = count + 1;
		}
		return count;
	}

	public function warningCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.warningLogged)
				count = count + 1;
		}
		return count;
	}

	public function activeGoalClearedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.activeGoalCleared)
				count = count + 1;
		}
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";stopped=" + Std.string(stoppedCount()) + ";skipped="
			+ Std.string(skippedCount()) + ";noOps=" + Std.string(noOpCount()) + ";warnings=" + Std.string(warningCount()) + ";activeCleared="
			+ Std.string(activeGoalClearedCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
