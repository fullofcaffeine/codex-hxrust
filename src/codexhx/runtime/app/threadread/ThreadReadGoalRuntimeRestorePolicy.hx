package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadGoalRuntimeRestorePolicy {
	public static function buildCases(requests:Array<ThreadReadGoalRuntimeRestoreRequest>):ThreadReadGoalRuntimeRestoreReport {
		final outcomes:Array<ThreadReadGoalRuntimeRestoreOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadGoalRuntimeRestoreReport(outcomes);
	}

	public static function build(request:ThreadReadGoalRuntimeRestoreRequest):ThreadReadGoalRuntimeRestoreOutcome {
		if (!request.runtimePresent)
			return ThreadReadGoalRuntimeRestoreOutcome.runtimeMissing();
		if (!request.runtimeEnabled)
			return ThreadReadGoalRuntimeRestoreOutcome.disabled(request.previousActiveGoalId);
		if (!request.stateReadOk)
			return ThreadReadGoalRuntimeRestoreOutcome.failure(request.previousActiveGoalId, request.stateReadErrorCode);

		if (request.storedGoal != null && request.storedGoal.status == ThreadGoalStatus.Active) {
			return ThreadReadGoalRuntimeRestoreOutcome.restored(request.previousActiveGoalId, request.storedGoalId);
		}

		if (request.storedGoal == null) {
			return ThreadReadGoalRuntimeRestoreOutcome.cleared("stored_goal_missing_cleared", request.previousActiveGoalId,
				"missing stored goal clears active goal accounting");
		}

		return ThreadReadGoalRuntimeRestoreOutcome.cleared("stored_goal_not_active_cleared", request.previousActiveGoalId,
			"stored non-active goal clears active goal accounting");
	}
}
