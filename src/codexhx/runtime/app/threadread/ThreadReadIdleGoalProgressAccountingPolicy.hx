package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadIdleGoalProgressAccountingPolicy {
	public static function buildCases(requests:Array<ThreadReadIdleGoalProgressAccountingRequest>):ThreadReadIdleGoalProgressAccountingReport {
		final outcomes:Array<ThreadReadIdleGoalProgressAccountingOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadIdleGoalProgressAccountingReport(outcomes);
	}

	public static function build(request:ThreadReadIdleGoalProgressAccountingRequest):ThreadReadIdleGoalProgressAccountingOutcome {
		if (!request.idleProgressSnapshotAvailable) {
			return ThreadReadIdleGoalProgressAccountingOutcome.missingSnapshot();
		}

		if (request.dbOutcomeKind == ThreadReadGoalAccountingDbOutcomeKind.Error) {
			return ThreadReadIdleGoalProgressAccountingOutcome.stateError(request.dbOutcomeKind, request.dbErrorCode);
		}

		if (request.dbOutcomeKind == ThreadReadGoalAccountingDbOutcomeKind.Unchanged) {
			return ThreadReadIdleGoalProgressAccountingOutcome.unchanged(request.snapshotExpectedGoalId);
		}

		if (request.updatedGoal == null) {
			return ThreadReadIdleGoalProgressAccountingOutcome.stateError(
				request.dbOutcomeKind,
				"updated_goal_missing"
			);
		}

		final status = request.updatedGoal.status;
		final activeGoalCleared = shouldClearActiveGoal(status, request.disposition);
		final budgetLimitReportCleared = status != ThreadGoalStatus.BudgetLimited;
		final terminalMetricRecorded = request.previousStatus != status && ThreadGoalStatus.isTerminal(status);
		return ThreadReadIdleGoalProgressAccountingOutcome.updated(
			codeForUpdated(status, request.disposition),
			goalIdFor(request),
			status,
			request.snapshotTimeDeltaSeconds,
			activeGoalCleared,
			budgetLimitReportCleared,
			terminalMetricRecorded,
			request.disposition
		);
	}

	static function codeForUpdated(status:String, disposition:ThreadReadGoalAccountingDisposition):String {
		if (status == ThreadGoalStatus.BudgetLimited) {
			if (disposition == ThreadReadGoalAccountingDisposition.ClearActive) {
				return "budget_limited_idle_progress_updated_clear_active";
			}
			return "budget_limited_idle_progress_updated_keep_active";
		}
		return "active_idle_progress_updated";
	}

	static function goalIdFor(request:ThreadReadIdleGoalProgressAccountingRequest):String {
		if (request.updatedGoalId.length > 0) return request.updatedGoalId;
		return request.snapshotExpectedGoalId;
	}

	static function shouldClearActiveGoal(status:String, disposition:ThreadReadGoalAccountingDisposition):Bool {
		if (status == ThreadGoalStatus.Active) return false;
		if (status == ThreadGoalStatus.BudgetLimited) {
			return disposition == ThreadReadGoalAccountingDisposition.ClearActive;
		}
		return status == ThreadGoalStatus.Paused
			|| status == ThreadGoalStatus.Blocked
			|| status == ThreadGoalStatus.UsageLimited
			|| status == ThreadGoalStatus.Complete;
	}
}
