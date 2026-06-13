package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadBudgetLimitGoalSteeringPolicy {
	public static function buildCases(requests:Array<ThreadReadBudgetLimitGoalSteeringRequest>):ThreadReadBudgetLimitGoalSteeringReport {
		final outcomes:Array<ThreadReadBudgetLimitGoalSteeringOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadBudgetLimitGoalSteeringReport(outcomes);
	}

	public static function build(request:ThreadReadBudgetLimitGoalSteeringRequest):ThreadReadBudgetLimitGoalSteeringOutcome {
		if (!request.progressOk) {
			return ThreadReadBudgetLimitGoalSteeringOutcome.failure(
				"progress_accounting_failed",
				false,
				"item=none",
				"failed to account active goal progress after tool finish: " + request.progressErrorCode
			);
		}

		if (!request.progressAvailable || request.goal == null) {
			return ThreadReadBudgetLimitGoalSteeringOutcome.makeSkipped(
				"active_progress_missing_skip",
				false,
				false,
				false,
				"item=none",
				"tool/finish->account_active_goal_progress->none->skip",
				"no active goal progress was available for this tool finish"
			);
		}

		if (request.goal.status != ThreadGoalStatus.BudgetLimited) {
			return ThreadReadBudgetLimitGoalSteeringOutcome.makeSkipped(
				"goal_not_budget_limited_skip",
				true,
				false,
				false,
				"item=none",
				"tool/finish->account_active_goal_progress->not_budget_limited->skip",
				"budget-limit steering is emitted only after progress returns a budget-limited goal"
			);
		}

		if (request.budgetLimitAlreadyReported) {
			return ThreadReadBudgetLimitGoalSteeringOutcome.makeSkipped(
				"budget_limit_already_reported_skip",
				true,
				true,
				true,
				"item=none",
				"tool/finish->account_active_goal_progress->budget_limited->mark_budget_limit_reported/duplicate->skip",
				"budget-limit steering was already reported for this goal"
			);
		}

		final steering = ThreadReadGoalSteeringBuilder.build(new ThreadReadGoalSteeringRequest(
			ThreadReadGoalSteeringItemKind.BudgetLimit,
			request.goal,
			null,
			false
		));
		final injection = ThreadReadActiveTurnGoalSteeringInjectionPolicy.build(new ThreadReadActiveTurnGoalSteeringInjectionRequest(
			steering,
			request.threadManagerAvailable,
			request.liveThreadAvailable,
			request.activeTurnRunning
		));
		return ThreadReadBudgetLimitGoalSteeringOutcome.fromInjection(injection, request.goalId);
	}
}
