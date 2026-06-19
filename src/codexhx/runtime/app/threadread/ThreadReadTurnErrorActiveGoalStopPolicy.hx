package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadTurnErrorActiveGoalStopPolicy {
	public static function buildCases(requests:Array<ThreadReadTurnErrorActiveGoalStopRequest>):ThreadReadTurnErrorActiveGoalStopReport {
		final outcomes:Array<ThreadReadTurnErrorActiveGoalStopOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadTurnErrorActiveGoalStopReport(outcomes);
	}

	public static function build(request:ThreadReadTurnErrorActiveGoalStopRequest):ThreadReadTurnErrorActiveGoalStopOutcome {
		final reason = stopReasonFor(request.errorKind);
		final targetStatus = targetStatusFor(reason);
		if (!request.runtimeAvailable) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.runtimeMissing(request.errorKind, reason, targetStatus);
		}
		if (!request.runtimeEnabled) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.runtimeDisabled(request.errorKind, reason, targetStatus);
		}
		if (!request.goalStatePermitOk) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.permitFailure(request.errorKind, reason, targetStatus);
		}
		if (!request.currentTurnIsActiveGoal) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.nonCurrent(request.errorKind, reason, targetStatus);
		}

		final progressEventId = request.turnId + ":" + eventNameFor(reason) + "-progress";
		if (request.accountingOutcome == null || !request.accountingOutcome.ok) {
			final code = request.accountingOutcome == null ? "accounting_outcome_missing" : request.accountingOutcome.code;
			return ThreadReadTurnErrorActiveGoalStopOutcome.accountingFailure(request.errorKind, reason, targetStatus, progressEventId, code);
		}

		if (request.storedGoalLookupOutcomeKind == ThreadReadStoredGoalLookupOutcomeKind.Error) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.lookupFailure(request.errorKind, reason, targetStatus, progressEventId, request.accountingOutcome,
				request.storedGoalLookupErrorCode);
		}

		if (request.storedGoalLookupOutcomeKind == ThreadReadStoredGoalLookupOutcomeKind.Missing || request.storedGoal == null) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.missingStoredGoal(request.errorKind, reason, targetStatus, progressEventId,
				request.accountingOutcome);
		}

		final previousStatus = request.storedGoal.status;
		if (!canStop(previousStatus, targetStatus)) {
			return ThreadReadTurnErrorActiveGoalStopOutcome.notStoppable(request.errorKind, reason, targetStatus, progressEventId, request.accountingOutcome,
				previousStatus);
		}

		return ThreadReadTurnErrorActiveGoalStopOutcome.stopped(request.errorKind, reason, targetStatus, progressEventId,
			request.turnId + ":" + eventNameFor(reason), request.accountingOutcome, previousStatus);
	}

	static function stopReasonFor(errorKind:ThreadReadTurnErrorKind):ThreadReadActiveGoalStopReason {
		if (errorKind == ThreadReadTurnErrorKind.UsageLimitExceeded)
			return ThreadReadActiveGoalStopReason.UsageLimit;
		return ThreadReadActiveGoalStopReason.TurnError;
	}

	static function targetStatusFor(reason:ThreadReadActiveGoalStopReason):String {
		return reason == ThreadReadActiveGoalStopReason.UsageLimit ? ThreadGoalStatus.UsageLimited : ThreadGoalStatus.Blocked;
	}

	static function eventNameFor(reason:ThreadReadActiveGoalStopReason):String {
		return reason == ThreadReadActiveGoalStopReason.UsageLimit ? "usage-limit" : "turn-error";
	}

	static function canStop(previousStatus:String, targetStatus:String):Bool {
		return previousStatus == ThreadGoalStatus.Active
			|| (previousStatus == ThreadGoalStatus.BudgetLimited && targetStatus == ThreadGoalStatus.UsageLimited);
	}
}
