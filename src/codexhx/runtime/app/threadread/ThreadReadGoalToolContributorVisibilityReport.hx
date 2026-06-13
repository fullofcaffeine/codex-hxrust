package codexhx.runtime.app.threadread;

class ThreadReadGoalToolContributorVisibilityReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadGoalToolContributorVisibilityOutcome>;

	public function new(outcomes:Array<ThreadReadGoalToolContributorVisibilityOutcome>) {
		this.schema = "codex-hxrust.thread-read-goal-tool-contributor-visibility-report.v1";
		this.outcomes = outcomes;
	}

	public function visibleCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.toolsVisible) count = count + 1;
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (!outcome.toolsVisible) count = count + 1;
		return count;
	}

	public function returnedToolCount():Int {
		var count = 0;
		for (outcome in outcomes) count = count + outcome.returnedToolCount;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) parts.push(outcome.summary());
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";visible=" + Std.string(visibleCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";returnedTools=" + Std.string(returnedToolCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
