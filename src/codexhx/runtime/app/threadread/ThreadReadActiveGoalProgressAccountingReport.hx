package codexhx.runtime.app.threadread;

class ThreadReadActiveGoalProgressAccountingReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadActiveGoalProgressAccountingOutcome>;

	public function new(outcomes:Array<ThreadReadActiveGoalProgressAccountingOutcome>) {
		this.schema = "codex-hxrust.thread-read-active-goal-progress-accounting-report.v1";
		this.outcomes = outcomes;
	}

	public function updatedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.progressUpdated)
				count = count + 1;
		}
		return count;
	}

	public function unchangedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.code == "state_accounting_unchanged")
				count = count + 1;
		}
		return count;
	}

	public function missingSnapshotCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.code == "progress_snapshot_missing")
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

	public function emittedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.threadGoalUpdatedEmitted)
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
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";updated=" + Std.string(updatedCount()) + ";unchanged="
			+ Std.string(unchangedCount()) + ";missingSnapshot=" + Std.string(missingSnapshotCount()) + ";failed=" + Std.string(failureCount()) + ";emitted="
			+ Std.string(emittedCount()) + ";activeCleared=" + Std.string(activeGoalClearedCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
