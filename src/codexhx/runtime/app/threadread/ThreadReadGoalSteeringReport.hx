package codexhx.runtime.app.threadread;

class ThreadReadGoalSteeringReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadGoalSteeringOutcome>;

	public function new(outcomes:Array<ThreadReadGoalSteeringOutcome>) {
		this.schema = "codex-hxrust.thread-read-goal-steering-report.v1";
		this.outcomes = outcomes;
	}

	public function emittedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.emitted)
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

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";emitted=" + Std.string(emittedCount()) + ";skipped="
			+ Std.string(skippedCount()) + ";failed=" + Std.string(failureCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
