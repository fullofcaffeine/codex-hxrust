package codexhx.runtime.app.threadread;

class ThreadReadResumeGoalSnapshotReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadResumeGoalSnapshotOutcome>;

	public function new(outcomes:Array<ThreadReadResumeGoalSnapshotOutcome>) {
		this.schema = "codex-hxrust.thread-read-resume-goal-snapshot-report.v1";
		this.outcomes = outcomes;
	}

	public function snapshotCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.snapshotDelivered) count = count + 1;
		}
		return count;
	}

	public function updatedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.goalUpdated) count = count + 1;
		}
		return count;
	}

	public function clearedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.goalCleared) count = count + 1;
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

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";snapshots=" + Std.string(snapshotCount())
			+ ";updated=" + Std.string(updatedCount())
			+ ";cleared=" + Std.string(clearedCount())
			+ ";skipped=" + Std.string(skippedCount())
			+ ";failed=" + Std.string(failureCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
