package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadTurnStartGoalAccountingPolicy {
	public static function buildCases(requests:Array<ThreadReadTurnStartGoalAccountingRequest>):ThreadReadTurnStartGoalAccountingReport {
		final outcomes:Array<ThreadReadTurnStartGoalAccountingOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadTurnStartGoalAccountingReport(outcomes);
	}

	public static function build(request:ThreadReadTurnStartGoalAccountingRequest):ThreadReadTurnStartGoalAccountingOutcome {
		if (!request.runtimeAvailable) return ThreadReadTurnStartGoalAccountingOutcome.runtimeMissing();
		if (!request.runtimeEnabled) return ThreadReadTurnStartGoalAccountingOutcome.runtimeDisabled();
		if (request.collaborationMode == ThreadReadTurnStartCollaborationMode.Plan) {
			return ThreadReadTurnStartGoalAccountingOutcome.planMode(request.turnId);
		}
		if (request.storedGoalLookupOutcomeKind == ThreadReadStoredGoalLookupOutcomeKind.Error) {
			return ThreadReadTurnStartGoalAccountingOutcome.lookupError(request.storedGoalLookupErrorCode);
		}
		if (request.storedGoalLookupOutcomeKind == ThreadReadStoredGoalLookupOutcomeKind.Missing || request.storedGoal == null) {
			return ThreadReadTurnStartGoalAccountingOutcome.missingGoal();
		}

		final status = request.storedGoal.status;
		if (status != ThreadGoalStatus.Active && status != ThreadGoalStatus.BudgetLimited) {
			return ThreadReadTurnStartGoalAccountingOutcome.nonActiveGoal(status);
		}

		final goalId = request.storedGoalId.length > 0 ? request.storedGoalId : request.storedGoal.objective;
		final budgetLimitReportCleared = request.budgetLimitReportedGoalId.length > 0 && request.budgetLimitReportedGoalId != goalId;
		return ThreadReadTurnStartGoalAccountingOutcome.markedActive(goalId, status, budgetLimitReportCleared);
	}
}
