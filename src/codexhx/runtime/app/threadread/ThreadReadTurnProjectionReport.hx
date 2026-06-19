package codexhx.runtime.app.threadread;

class ThreadReadTurnProjectionReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTurnProjectionOutcome>;

	public function new(outcomes:Array<ThreadReadTurnProjectionOutcome>) {
		this.schema = "codex-hxrust.thread-read-turn-projection-report.v1";
		this.outcomes = outcomes;
	}

	public function okCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.ok)
				count = count + 1;
		}
		return count;
	}

	public function failureCount():Int {
		return outcomes.length - okCount();
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";ok=" + Std.string(okCount()) + ";failed=" + Std.string(failureCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
