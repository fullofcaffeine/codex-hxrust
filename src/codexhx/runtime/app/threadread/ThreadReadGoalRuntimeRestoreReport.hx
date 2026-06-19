package codexhx.runtime.app.threadread;

class ThreadReadGoalRuntimeRestoreReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadGoalRuntimeRestoreOutcome>;

	public function new(outcomes:Array<ThreadReadGoalRuntimeRestoreOutcome>) {
		this.schema = "codex-hxrust.thread-read-goal-runtime-restore-report.v1";
		this.outcomes = outcomes;
	}

	public function restoredCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.restoredActiveGoal)
				count = count + 1;
		}
		return count;
	}

	public function clearedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.clearedActiveGoal)
				count = count + 1;
		}
		return count;
	}

	public function metricCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.resumedMetricRecorded)
				count = count + 1;
		}
		return count;
	}

	public function noopCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.code == "runtime_missing_skip" || outcome.code == "runtime_disabled_noop")
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

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";restored=" + Std.string(restoredCount()) + ";cleared="
			+ Std.string(clearedCount()) + ";metrics=" + Std.string(metricCount()) + ";noop=" + Std.string(noopCount()) + ";failed="
			+ Std.string(failureCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
