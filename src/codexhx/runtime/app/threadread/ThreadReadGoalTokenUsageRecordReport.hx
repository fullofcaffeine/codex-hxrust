package codexhx.runtime.app.threadread;

class ThreadReadGoalTokenUsageRecordReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadGoalTokenUsageRecordOutcome>;

	public function new(outcomes:Array<ThreadReadGoalTokenUsageRecordOutcome>) {
		this.schema = "codex-hxrust.thread-read-goal-token-usage-record-report.v1";
		this.outcomes = outcomes;
	}

	public function recordedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.recorded) count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.recorded) count = count + 1;
		}
		return count;
	}

	public function currentUsageUpdatedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.currentUsageUpdated) count = count + 1;
		}
		return count;
	}

	public function ignoredReasoningCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.ignoredReasoningOutputTokens) count = count + 1;
		}
		return count;
	}

	public function ignoredTotalCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.ignoredTotalTokens) count = count + 1;
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
			+ ";recorded=" + Std.string(recordedCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";currentUsageUpdated=" + Std.string(currentUsageUpdatedCount())
			+ ";ignoredReasoning=" + Std.string(ignoredReasoningCount())
			+ ";ignoredTotal=" + Std.string(ignoredTotalCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
