package codexhx.runtime.model.request;

class ModelRequestEnvelopeReport {
	public final schema:String;
	public final outcomes:Array<ModelRequestEnvelopeOutcome>;

	public function new(outcomes:Array<ModelRequestEnvelopeOutcome>) {
		this.schema = "codex-hxrust.model-request-envelope-report.v1";
		this.outcomes = outcomes;
	}

	public function successCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.ok) count = count + 1;
		return count;
	}

	public function errorCount():Int {
		var count = 0;
		for (outcome in outcomes) if (!outcome.ok) count = count + 1;
		return count;
	}

	public function liveRouteDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.code == "live_network_disabled" || outcome.code == "websocket_unsupported") count = count + 1;
		return count;
	}

	public function planDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.code == "turn_model_plan_denied") count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) parts.push(outcome.summary());
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";success=" + Std.string(successCount())
			+ ";errors=" + Std.string(errorCount())
			+ ";liveRouteDenied=" + Std.string(liveRouteDeniedCount())
			+ ";planDenied=" + Std.string(planDeniedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
