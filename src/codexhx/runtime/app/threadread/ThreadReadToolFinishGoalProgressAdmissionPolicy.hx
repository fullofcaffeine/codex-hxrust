package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadToolFinishGoalProgressAdmissionPolicy {
	public static function buildCases(requests:Array<ThreadReadToolFinishGoalProgressAdmissionRequest>):ThreadReadToolFinishGoalProgressAdmissionReport {
		final outcomes:Array<ThreadReadToolFinishGoalProgressAdmissionOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadToolFinishGoalProgressAdmissionReport(outcomes);
	}

	public static function build(request:ThreadReadToolFinishGoalProgressAdmissionRequest):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		if (!request.runtimeAvailable)
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.runtimeMissing(request);

		final toolAttemptCounts = countsForGoalProgress(request);
		final updateGoalSelfTool = isBareUpdateGoal(request);
		if (!request.runtimeEnabled) {
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.runtimeDisabled(request, toolAttemptCounts, updateGoalSelfTool);
		}
		if (!toolAttemptCounts) {
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.outcomeNotCounted(request, toolAttemptCounts, updateGoalSelfTool);
		}
		if (updateGoalSelfTool) {
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.updateGoalSelfToolSkip(request, toolAttemptCounts);
		}
		if (request.accountingOutcome == null)
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.accountingMissing(request);
		if (!request.accountingOutcome.ok) {
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.accountingFailed(request, request.accountingOutcome.code);
		}
		if (!request.accountingOutcome.progressReturned) {
			return ThreadReadToolFinishGoalProgressAdmissionOutcome.noProgress(request, request.accountingOutcome.code);
		}
		return ThreadReadToolFinishGoalProgressAdmissionOutcome.progressReturnedOutcome(request, request.accountingOutcome.code,
			request.accountingOutcome.status == ThreadGoalStatus.BudgetLimited);
	}

	static function countsForGoalProgress(request:ThreadReadToolFinishGoalProgressAdmissionRequest):Bool {
		if (request.outcomeKind == ThreadReadToolCallOutcomeKind.Completed)
			return true;
		if (request.outcomeKind == ThreadReadToolCallOutcomeKind.Failed)
			return request.failedHandlerExecuted;
		return false;
	}

	static function isBareUpdateGoal(request:ThreadReadToolFinishGoalProgressAdmissionRequest):Bool {
		return request.toolNamespace.length == 0 && request.toolName == "update_goal";
	}
}
