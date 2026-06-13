package codexhx.runtime.app.threadread;

class ThreadReadTurnItemsListReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTurnItemsListOutcome>;

	public function new(outcomes:Array<ThreadReadTurnItemsListOutcome>) {
		this.schema = "codex-hxrust.thread-read-turn-items-list-report.v1";
		this.outcomes = outcomes;
	}

	public function unsupportedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.code == "method_not_found") count = count + 1;
		}
		return count;
	}

	public function failureCount():Int {
		return outcomes.length;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema
			+ ";requests=" + Std.string(outcomes.length)
			+ ";unsupported=" + Std.string(unsupportedCount())
			+ ";failed=" + Std.string(failureCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
