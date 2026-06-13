package codexhx.native.state;

class StateSqliteAdapterReport {
	public final schema:String;
	public final outcomes:Array<StateSqliteOperationOutcome>;

	public function new(outcomes:Array<StateSqliteOperationOutcome>) {
		this.schema = "codex-hxrust.native-state-adapter-report.v1";
		this.outcomes = outcomes;
	}

	public function okCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.ok) count = count + 1;
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
		return "schema=" + schema
			+ ";operations=" + Std.string(outcomes.length)
			+ ";ok=" + Std.string(okCount())
			+ ";failed=" + Std.string(failureCount())
			+ ";outcomes=[" + parts.join("||") + "]";
	}
}
