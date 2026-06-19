package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageReplayDeliveryReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTokenUsageReplayDeliveryOutcome>;

	public function new(outcomes:Array<ThreadReadTokenUsageReplayDeliveryOutcome>) {
		this.schema = "codex-hxrust.thread-read-token-usage-replay-delivery-report.v1";
		this.outcomes = outcomes;
	}

	public function deliveredCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.delivered)
				count = count + 1;
		}
		return count;
	}

	public function skippedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.skipped)
				count = count + 1;
		}
		return count;
	}

	public function failureCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (!outcome.ok)
				count = count + 1;
		}
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";delivered=" + Std.string(deliveredCount()) + ";skipped="
			+ Std.string(skippedCount()) + ";failed=" + Std.string(failureCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
