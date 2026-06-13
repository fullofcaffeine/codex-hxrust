package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnGoalSteeringInjectionReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadActiveTurnGoalSteeringInjectionOutcome>;

	public function new(outcomes:Array<ThreadReadActiveTurnGoalSteeringInjectionOutcome>) {
		this.schema = "codex-hxrust.thread-read-active-turn-goal-steering-injection-report.v1";
		this.outcomes = outcomes;
	}

	public function injectedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.injected) count = count + 1;
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

	public function returnedUnchangedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.returnedItemUnchanged) count = count + 1;
		}
		return count;
	}

	public function injectedUnchangedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.injectedItemUnchanged) count = count + 1;
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
			+ ";injected=" + Std.string(injectedCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";failed=" + Std.string(failureCount())
			+ ";returnedUnchanged=" + Std.string(returnedUnchangedCount())
			+ ";injectedUnchanged=" + Std.string(injectedUnchangedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
