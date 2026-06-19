package codexhx.runtime.model.stream;

class ModelStreamRouteReport {
	public final schema:String;
	public final outcomes:Array<ModelStreamRouteOutcome>;

	public function new(outcomes:Array<ModelStreamRouteOutcome>) {
		this.schema = "codex-hxrust.model-stream-route-report.v1";
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

	public function cancelledCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.cancelled)
				count = count + 1;
		return count;
	}

	public function envelopeDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes)
			if (outcome.code == "model_request_envelope_denied")
				count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes)
			parts.push(outcome.summary());
		return "schema=" + schema + ";cases=" + Std.string(outcomes.length) + ";success=" + Std.string(successCount()) + ";errors="
			+ Std.string(errorCount()) + ";cancelled=" + Std.string(cancelledCount()) + ";envelopeDenied=" + Std.string(envelopeDeniedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
