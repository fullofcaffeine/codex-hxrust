package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadActiveGoalProgressAccountingPolicy {
	public static function buildCases(requests:Array<ThreadReadActiveGoalProgressAccountingRequest>):ThreadReadActiveGoalProgressAccountingReport {
		final outcomes:Array<ThreadReadActiveGoalProgressAccountingOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadActiveGoalProgressAccountingReport(outcomes);
	}

	public static function build(request:ThreadReadActiveGoalProgressAccountingRequest):ThreadReadActiveGoalProgressAccountingOutcome {
		if (!request.progressSnapshotAvailable) {
			return ThreadReadActiveGoalProgressAccountingOutcome.missingSnapshot(request.turnId);
		}

		if (request.dbOutcomeKind == ThreadReadGoalAccountingDbOutcomeKind.Error) {
			return ThreadReadActiveGoalProgressAccountingOutcome.stateError(request.dbOutcomeKind, request.dbErrorCode);
		}

		if (request.dbOutcomeKind == ThreadReadGoalAccountingDbOutcomeKind.Unchanged) {
			return ThreadReadActiveGoalProgressAccountingOutcome.unchanged(request.snapshotExpectedGoalId);
		}

		if (request.updatedGoal == null) {
			return ThreadReadActiveGoalProgressAccountingOutcome.stateError(
				request.dbOutcomeKind,
				"updated_goal_missing"
			);
		}

		final status = request.updatedGoal.status;
		final activeGoalCleared = shouldClearActiveGoal(status, request.disposition);
		final budgetLimitReportCleared = status != ThreadGoalStatus.BudgetLimited;
		final terminalMetricRecorded = request.previousStatus != status && ThreadGoalStatus.isTerminal(status);
		return ThreadReadActiveGoalProgressAccountingOutcome.updated(
			codeForUpdated(status, request.disposition),
			goalIdFor(request),
			status,
			request.snapshotTimeDeltaSeconds,
			request.snapshotTokenDelta,
			activeGoalCleared,
			budgetLimitReportCleared,
			terminalMetricRecorded,
			request.disposition
		);
	}

	static function codeForUpdated(status:String, disposition:ThreadReadGoalAccountingDisposition):String {
		if (status == ThreadGoalStatus.BudgetLimited) {
			if (disposition == ThreadReadGoalAccountingDisposition.ClearActive) {
				return "budget_limited_progress_updated_clear_active";
			}
			return "budget_limited_progress_updated_keep_active";
		}
		return "active_goal_progress_updated";
	}

	static function goalIdFor(request:ThreadReadActiveGoalProgressAccountingRequest):String {
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
