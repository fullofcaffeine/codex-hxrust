package codexhx.runtime.model.streamitem;

class ModelStreamItemReducerReport {
	public final schema:String;
	public final outcomes:Array<ModelStreamItemReducerOutcome>;

	public function new(outcomes:Array<ModelStreamItemReducerOutcome>) {
		this.schema = "codex-hxrust.model-stream-item-reducer-report.v1";
		this.outcomes = outcomes;
	}

	public function successCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.ok)
				count = count + 1;
		return count;
	}

	public function errorCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (!outcome.ok)
				count = count + 1;
		return count;
	}

	public function toolCallCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.toolCallCount;
		return count;
	}

	public function assistantDeltaCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.assistantDeltaCount;
		return count;
	}

	public function reasoningDeltaCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.reasoningDeltaCount;
		return count;
	}

	public function toolInputDeltaCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.toolInputDeltaCount;
		return count;
	}

	public function toolInputDeltaIgnoredCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.toolInputDeltaIgnoredCount;
		return count;
	}

	public function toolArgumentDiffEventCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.toolArgumentDiffEventCount;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";success=" + Std.string(successCount()) + ";errors="
			+ Std.string(errorCount()) + ";toolCalls=" + Std.string(toolCallCount()) + ";assistantDeltas=" + Std.string(assistantDeltaCount())
			+ ";reasoningDeltas=" + Std.string(reasoningDeltaCount()) + ";toolInputDeltas=" + Std.string(toolInputDeltaCount()) + ";toolInputDeltaIgnored="
			+ Std.string(toolInputDeltaIgnoredCount()) + ";toolArgumentDiffEvents=" + Std.string(toolArgumentDiffEventCount()) + ";outcomes=["
			+ parts.join("##") + "]";
	}
}
