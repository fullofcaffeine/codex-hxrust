package codexhx.state.goals;

import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadGoalStore {
	public static inline final maxObjectiveChars = 4000;

	final threadId:String;
	var goal:ThreadGoal;

	public function new(threadId:String) {
		this.threadId = threadId;
		this.goal = null;
	}

	public function get():ThreadGoal {
		return goal;
	}

	public function createGoal(objective:String, hasTokenBudget:Bool, tokenBudget:Int, now:Int):GoalOperationOutcome {
		final trimmed = StringTools.trim(objective);
		final validation = validateObjective(trimmed);
		if (!validation.ok)
			return validation;
		final budgetValidation = validateBudget(hasTokenBudget, tokenBudget);
		if (!budgetValidation.ok)
			return budgetValidation;
		if (goal != null && !ThreadGoalStatus.isTerminal(goal.status)) {
			return GoalOperationOutcome.failure("goal_already_exists",
				"cannot create a new goal because this thread has an unfinished goal; complete the existing goal first");
		}

		goal = new ThreadGoal(threadId, trimmed, ThreadGoalStatus.Active, hasTokenBudget, tokenBudget, 0, 0, now, now);
		return GoalOperationOutcome.success(goal);
	}

	public function setObjective(objective:String, status:String, now:Int):GoalOperationOutcome {
		final trimmed = StringTools.trim(objective);
		final validation = validateObjective(trimmed);
		if (!validation.ok)
			return validation;
		final statusValidation = validateStatus(status);
		if (!statusValidation.ok)
			return statusValidation;
		if (goal == null) {
			goal = new ThreadGoal(threadId, trimmed, status, false, 0, 0, 0, now, now);
		} else {
			goal = goal.withObjective(trimmed, status, now);
		}
		return GoalOperationOutcome.success(goal);
	}

	public function setStatus(status:String, now:Int):GoalOperationOutcome {
		final statusValidation = validateStatus(status);
		if (!statusValidation.ok)
			return statusValidation;
		if (goal == null) {
			return GoalOperationOutcome.failure("missing_goal", "cannot update goal because this thread has no goal");
		}
		goal = goal.withStatus(status, now);
		return GoalOperationOutcome.success(goal);
	}

	public function setBudget(hasTokenBudget:Bool, tokenBudget:Int, now:Int):GoalOperationOutcome {
		final validation = validateBudget(hasTokenBudget, tokenBudget);
		if (!validation.ok)
			return validation;
		if (goal == null) {
			return GoalOperationOutcome.failure("missing_goal", "cannot update goal because this thread has no goal");
		}
		goal = goal.withBudget(hasTokenBudget, tokenBudget, now);
		return GoalOperationOutcome.success(goal);
	}

	public function accountUsage(tokens:Int, seconds:Int, now:Int):GoalOperationOutcome {
		if (goal == null) {
			return GoalOperationOutcome.failure("missing_goal", "cannot account goal usage because this thread has no goal");
		}
		if (tokens < 0 || seconds < 0) {
			return GoalOperationOutcome.failure("invalid_usage_delta", "goal usage deltas must be non-negative");
		}
		goal = goal.withUsage(goal.tokensUsed + tokens, goal.timeUsedSeconds + seconds, now);
		if (goal.hasTokenBudget && goal.tokensUsed >= goal.tokenBudget && goal.status == ThreadGoalStatus.Active) {
			goal = goal.withStatus(ThreadGoalStatus.BudgetLimited, now);
		}
		return GoalOperationOutcome.success(goal);
	}

	public function clear():GoalOperationOutcome {
		final cleared = goal != null;
		goal = null;
		return GoalOperationOutcome.clearResult(cleared);
	}

	public static function validateObjective(value:String):GoalOperationOutcome {
		if (value.length == 0) {
			return GoalOperationOutcome.failure("invalid_goal_objective", "goal objective must not be empty");
		}
		if (value.length > maxObjectiveChars) {
			return GoalOperationOutcome.failure("invalid_goal_objective", "goal objective must be at most 4000 characters");
		}
		return GoalOperationOutcome.success(null);
	}

	public static function validateBudget(hasTokenBudget:Bool, tokenBudget:Int):GoalOperationOutcome {
		if (hasTokenBudget && tokenBudget <= 0) {
			return GoalOperationOutcome.failure("invalid_goal_budget", "goal budgets must be positive when provided");
		}
		return GoalOperationOutcome.success(null);
	}

	public static function validateStatus(status:String):GoalOperationOutcome {
		if (!ThreadGoalStatus.isValid(status)) {
			return GoalOperationOutcome.failure("invalid_goal_status", "unsupported thread goal status");
		}
		return GoalOperationOutcome.success(null);
	}
}
