package codexhx.runtime.app.threadread;

class ThreadReadTurnGoalFinalizationReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTurnGoalFinalizationOutcome>;

	public function new(outcomes:Array<ThreadReadTurnGoalFinalizationOutcome>) {
		this.schema = "codex-hxrust.thread-read-turn-goal-finalization-report.v1";
		this.outcomes = outcomes;
	}

	public function finalizedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.finishTurnCalled) count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.accountingAttempted) count = count + 1;
		}
		return count;
	}

	public function accountingErrorCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.accountingAttempted && !outcome.accountingOk) count = count + 1;
		}
		return count;
	}

	public function warningCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.warningLogged) count = count + 1;
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

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";finalized=" + Std.string(finalizedCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";accountingErrors=" + Std.string(accountingErrorCount())
			+ ";warnings=" + Std.string(warningCount())
			+ ";activeCleared=" + Std.string(activeGoalClearedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
