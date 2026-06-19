package codexhx.runtime.app.persistence;

class PersistedThreadReadReport {
	public final schema:String;
	public final outcomes:Array<PersistedThreadReadOutcome>;

	public function new(outcomes:Array<PersistedThreadReadOutcome>) {
		this.schema = "codex-hxrust.persisted-thread-read-view-report.v1";
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
		return "schema=" + schema + ";reads=" + Std.string(outcomes.length) + ";ok=" + Std.string(okCount()) + ";failed=" + Std.string(failureCount())
			+ ";outcomes=[" + parts.join("||") + "]";
	}
}
