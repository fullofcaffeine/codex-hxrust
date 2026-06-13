package codexhx.runtime.app.threadread;

class ThreadReadCreateGoalToolReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadCreateGoalToolOutcome>;

	public function new(outcomes:Array<ThreadReadCreateGoalToolOutcome>) {
		this.schema = "codex-hxrust.thread-read-create-goal-tool-report.v1";
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

	public function previewWarningCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.previewWarningLogged) count = count + 1;
		return count;
	}

	public function eventEmittedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.eventEmitted) count = count + 1;
		return count;
	}

	public function insertAttemptedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.insertAttempted) count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) parts.push(outcome.summary());
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";success=" + Std.string(successCount())
			+ ";errors=" + Std.string(errorCount())
			+ ";previewWarnings=" + Std.string(previewWarningCount())
			+ ";eventsEmitted=" + Std.string(eventEmittedCount())
			+ ";insertAttempted=" + Std.string(insertAttemptedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
