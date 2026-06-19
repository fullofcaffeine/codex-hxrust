package codexhx.runtime.model.catalog;

class ModelCatalogReport {
	public final schema:String;
	public final outcomes:Array<ModelCatalogOutcome>;

	public function new(outcomes:Array<ModelCatalogOutcome>) {
		this.schema = "codex-hxrust.model-catalog-report.v1";
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

	public function hiddenDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.code == "hidden_model")
				count = count + 1;
		return count;
	}

	public function liveFetchDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.code == "live_model_fetch_disabled")
				count = count + 1;
		return count;
	}

	public function apiFilteredCount():Int {
		var count = 0;
		for (outcome in outcomes)
			count = count + outcome.apiFilteredCount;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";success=" + Std.string(successCount()) + ";errors="
			+ Std.string(errorCount()) + ";hiddenDenied=" + Std.string(hiddenDeniedCount()) + ";liveFetchDenied=" + Std.string(liveFetchDeniedCount())
			+ ";apiFiltered=" + Std.string(apiFilteredCount()) + ";outcomes=[" + parts.join("##") + "]";
	}
}
