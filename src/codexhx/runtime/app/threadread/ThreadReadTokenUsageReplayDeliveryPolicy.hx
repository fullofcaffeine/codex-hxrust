package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageReplayDeliveryPolicy {
	public static function planCases(requests:Array<ThreadReadTokenUsageReplayDeliveryRequest>):ThreadReadTokenUsageReplayDeliveryReport {
		final outcomes:Array<ThreadReadTokenUsageReplayDeliveryOutcome> = [];
		for (request in requests) {
			outcomes.push(plan(request));
		}
		return new ThreadReadTokenUsageReplayDeliveryReport(outcomes);
	}

	public static function plan(request:ThreadReadTokenUsageReplayDeliveryRequest):ThreadReadTokenUsageReplayDeliveryOutcome {
		if (!request.includeTurns) {
			return ThreadReadTokenUsageReplayDeliveryOutcome.makeSkipped(request.operation, "skipped_exclude_turns",
				"excludeTurns=true skips restored token usage replay");
		}
		if (!request.responseReady) {
			return ThreadReadTokenUsageReplayDeliveryOutcome.failure(request.operation, "response_not_ready",
				"restored token usage replay must be ordered after the JSON-RPC response");
		}
		if (request.connectionId.length == 0) {
			return ThreadReadTokenUsageReplayDeliveryOutcome.failure(request.operation, "invalid_connection_id",
				"connection-scoped restored usage replay requires a requesting connection id");
		}
		if (request.payload == null || !request.payload.ok) {
			final payloadCode = request.payload == null ? "missing_payload" : request.payload.code;
			return ThreadReadTokenUsageReplayDeliveryOutcome.makeSkipped(request.operation, "skipped_no_payload",
				"no restored token usage notification payload was available: " + payloadCode);
		}
		return ThreadReadTokenUsageReplayDeliveryOutcome.makeDelivered(request.operation, request.connectionId);
	}
}
