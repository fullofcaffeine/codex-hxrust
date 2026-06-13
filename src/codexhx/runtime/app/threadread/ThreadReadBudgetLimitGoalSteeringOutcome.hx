package codexhx.runtime.app.threadread;

class ThreadReadBudgetLimitGoalSteeringOutcome {
	public final ok:Bool;
	public final code:String;
	public final progressAccounted:Bool;
	public final budgetLimited:Bool;
	public final reportMarked:Bool;
	public final duplicateReportSkipped:Bool;
	public final steeringItemEmitted:Bool;
	public final injectionAttempted:Bool;
	public final injected:Bool;
	public final skipped:Bool;
	public final injectionCode:String;
	public final itemSummary:String;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		progressAccounted:Bool,
		budgetLimited:Bool,
		reportMarked:Bool,
		duplicateReportSkipped:Bool,
		steeringItemEmitted:Bool,
		injectionAttempted:Bool,
		injected:Bool,
		skipped:Bool,
		injectionCode:String,
		itemSummary:String,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.progressAccounted = progressAccounted;
		this.budgetLimited = budgetLimited;
		this.reportMarked = reportMarked;
		this.duplicateReportSkipped = duplicateReportSkipped;
		this.steeringItemEmitted = steeringItemEmitted;
		this.injectionAttempted = injectionAttempted;
		this.injected = injected;
		this.skipped = skipped;
		this.injectionCode = injectionCode;
		this.itemSummary = itemSummary;
		this.sequence = sequence;
		this.message = message;
	}

	public static function failure(code:String, progressAccounted:Bool, itemSummary:String, message:String):ThreadReadBudgetLimitGoalSteeringOutcome {
		return new ThreadReadBudgetLimitGoalSteeringOutcome(
			false,
			code,
			progressAccounted,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			"none",
			itemSummary,
			"tool/finish->account_active_goal_progress->error",
			message
		);
	}

	public static function makeSkipped(
		code:String,
		progressAccounted:Bool,
		budgetLimited:Bool,
		duplicateReportSkipped:Bool,
		itemSummary:String,
		sequence:String,
		message:String
	):ThreadReadBudgetLimitGoalSteeringOutcome {
		return new ThreadReadBudgetLimitGoalSteeringOutcome(
			true,
			code,
			progressAccounted,
			budgetLimited,
			false,
			duplicateReportSkipped,
			false,
			false,
			false,
			true,
			"none",
			itemSummary,
			sequence,
			message
		);
	}

	public static function fromInjection(injection:ThreadReadActiveTurnGoalSteeringInjectionOutcome, goalId:String):ThreadReadBudgetLimitGoalSteeringOutcome {
		return new ThreadReadBudgetLimitGoalSteeringOutcome(
			injection.ok,
			injection.injected ? "budget_limit_steering_injected" : "budget_limit_steering_injection_skipped",
			true,
			true,
			true,
			false,
			true,
			true,
			injection.injected,
			!injection.injected,
			injection.code,
			injection.itemSummary,
			"tool/finish->account_active_goal_progress->budget_limited->mark_budget_limit_reported:" + goalId + "->" + injection.sequence,
			injection.message
		);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";progressAccounted=" + (progressAccounted ? "true" : "false")
			+ ";budgetLimited=" + (budgetLimited ? "true" : "false")
			+ ";reportMarked=" + (reportMarked ? "true" : "false")
			+ ";duplicateReportSkipped=" + (duplicateReportSkipped ? "true" : "false")
			+ ";steeringItemEmitted=" + (steeringItemEmitted ? "true" : "false")
			+ ";injectionAttempted=" + (injectionAttempted ? "true" : "false")
			+ ";injected=" + (injected ? "true" : "false")
			+ ";skipped=" + (skipped ? "true" : "false")
			+ ";injectionCode=" + injectionCode
			+ ";itemSummary=" + itemSummary
			+ ";sequence=" + sequence
			+ ";message=" + message;
	}
}
