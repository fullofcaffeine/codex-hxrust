package codexhx.runtime.app.threadread;

class ThreadReadGetGoalToolReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadGetGoalToolOutcome>;

	public function new(outcomes:Array<ThreadReadGetGoalToolOutcome>) {
		this.schema = "codex-hxrust.thread-read-get-goal-tool-report.v1";
		this.outcomes = outcomes;
	}

	public function successCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.ok) count = count + 1;
		return count;
	}

	public function errorCount():Int {
		var count = 0;
		for (outcome in outcomes) if (!outcome.ok) count = count + 1;
		return count;
	}

	public function goalPresentCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.goalPresent) count = count + 1;
		return count;
	}

	public function readAttemptedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.readAttempted) count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) parts.push(outcome.summary());
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";success=" + Std.string(successCount())
			+ ";errors=" + Std.string(errorCount())
			+ ";goalPresent=" + Std.string(goalPresentCount())
			+ ";readAttempted=" + Std.string(readAttemptedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
