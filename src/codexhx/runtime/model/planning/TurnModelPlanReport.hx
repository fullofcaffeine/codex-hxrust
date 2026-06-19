package codexhx.runtime.model.planning;

class TurnModelPlanReport {
	public final schema:String;
	public final outcomes:Array<TurnModelPlanOutcome>;

	public function new(outcomes:Array<TurnModelPlanOutcome>) {
		this.schema = "codex-hxrust.turn-model-plan-report.v1";
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

	public function unsupportedCapabilityCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.code == "unsupported_tool_capability")
				count = count + 1;
		return count;
	}

	public function catalogDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.code == "model_catalog_denied")
				count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";success=" + Std.string(successCount()) + ";errors="
			+ Std.string(errorCount()) + ";unsupportedCapabilities=" + Std.string(unsupportedCapabilityCount()) + ";catalogDenied="
			+ Std.string(catalogDeniedCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
