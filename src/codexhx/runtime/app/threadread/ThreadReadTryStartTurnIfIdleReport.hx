package codexhx.runtime.app.threadread;

class ThreadReadTryStartTurnIfIdleReport {
	public final schema:String;
	public final outcomes:Array<ThreadReadTryStartTurnIfIdleOutcome>;

	public function new(outcomes:Array<ThreadReadTryStartTurnIfIdleOutcome>) {
		this.schema = "codex-hxrust.thread-read-try-start-turn-if-idle-report.v1";
		this.outcomes = outcomes;
	}

	public function acceptedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.accepted)
				count = count + 1;
		}
		return count;
	}

	public function rejectedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.rejected)
				count = count + 1;
		}
		return count;
	}

	public function noopCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.code == "empty_input_noop")
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

	public function returnedUnchangedCount():Int {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.returnedItemUnchanged)
				count = count + 1;
		}
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) {
			parts.push(outcome.summary());
		}
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";accepted=" + Std.string(acceptedCount()) + ";rejected="
			+ Std.string(rejectedCount()) + ";noop=" + Std.string(noopCount()) + ";failed=" + Std.string(failureCount()) + ";returnedUnchanged="
			+ Std.string(returnedUnchangedCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
