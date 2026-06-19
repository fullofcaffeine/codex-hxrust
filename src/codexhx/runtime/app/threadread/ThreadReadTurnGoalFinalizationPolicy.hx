package codexhx.runtime.app.threadread;

class ThreadReadTurnGoalFinalizationPolicy {
	public static function buildCases(requests:Array<ThreadReadTurnGoalFinalizationRequest>):ThreadReadTurnGoalFinalizationReport {
		final outcomes:Array<ThreadReadTurnGoalFinalizationOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadTurnGoalFinalizationReport(outcomes);
	}

	public static function build(request:ThreadReadTurnGoalFinalizationRequest):ThreadReadTurnGoalFinalizationOutcome {
		if (!request.runtimeAvailable)
			return ThreadReadTurnGoalFinalizationOutcome.runtimeMissing(request.kind);
		if (!request.runtimeEnabled)
			return ThreadReadTurnGoalFinalizationOutcome.runtimeDisabled(request.kind);

		final eventId = request.turnId + eventSuffix(request.kind);
		if (request.accountingOutcome == null || !request.accountingOutcome.ok) {
			final code = request.accountingOutcome == null ? "accounting_outcome_missing" : request.accountingOutcome.code;
			return ThreadReadTurnGoalFinalizationOutcome.accountingError(request.kind, eventId, code);
		}
		return ThreadReadTurnGoalFinalizationOutcome.finalized(request.kind, eventId, request.accountingOutcome);
	}

	static function eventSuffix(kind:ThreadReadTurnGoalFinalizationKind):String {
		return kind == ThreadReadTurnGoalFinalizationKind.TurnAbort ? ":turn-abort" : ":turn-stop";
	}
}
