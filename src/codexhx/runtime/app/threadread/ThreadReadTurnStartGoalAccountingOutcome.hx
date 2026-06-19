package codexhx.runtime.app.threadread;

class ThreadReadTurnStartGoalAccountingOutcome {
	public final ok:Bool;
	public final code:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final startTurnCalled:Bool;
	public final accountTokens:Bool;
	public final clearCurrentTurnGoalCalled:Bool;
	public final storedGoalLookupAttempted:Bool;
	public final storedGoalLookupOutcomeKind:String;
	public final storedGoalMarkedActive:Bool;
	public final currentTurnGoalId:String;
	public final wallClockActiveGoalId:String;
	public final budgetLimitReportCleared:Bool;
	public final stateLookupError:Bool;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, runtimeAvailable:Bool, runtimeEnabled:Bool, startTurnCalled:Bool, accountTokens:Bool, clearCurrentTurnGoalCalled:Bool,
			storedGoalLookupAttempted:Bool, storedGoalLookupOutcomeKind:String, storedGoalMarkedActive:Bool, currentTurnGoalId:String,
			wallClockActiveGoalId:String, budgetLimitReportCleared:Bool, stateLookupError:Bool, sequence:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.startTurnCalled = startTurnCalled;
		this.accountTokens = accountTokens;
		this.clearCurrentTurnGoalCalled = clearCurrentTurnGoalCalled;
		this.storedGoalLookupAttempted = storedGoalLookupAttempted;
		this.storedGoalLookupOutcomeKind = storedGoalLookupOutcomeKind;
		this.storedGoalMarkedActive = storedGoalMarkedActive;
		this.currentTurnGoalId = currentTurnGoalId;
		this.wallClockActiveGoalId = wallClockActiveGoalId;
		this.budgetLimitReportCleared = budgetLimitReportCleared;
		this.stateLookupError = stateLookupError;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing():ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true, "runtime_missing_skip", false, false, false, false, false, false, "none", false, "", "",
			false, false, "on_turn_start->goal_runtime_handle/none->return", "turn start skipped because the goal runtime was unavailable");
	}

	public static function runtimeDisabled():ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true, "runtime_disabled_skip", true, false, false, false, false, false, "none", false, "", "",
			false, false, "on_turn_start->runtime_disabled->return", "turn start skipped because the goal runtime was disabled");
	}

	public static function planMode(turnId:String):ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true, "plan_mode_current_goal_cleared", true, true, true, false, true, false, "none", false, "",
			"", true, false, "on_turn_start:" + turnId + "->start_turn:account_tokens=false->clear_current_turn_goal->return",
			"Plan mode starts accounting but clears the current turn goal before stored-goal lookup");
	}

	public static function lookupError(errorCode:String):ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true, "state_lookup_error_skip", true, true, true, true, false, true,
			ThreadReadStoredGoalLookupOutcomeKind.Error, false, "", "", false, true,
			"on_turn_start->start_turn:account_tokens=true->get_thread_goal/error:" + errorCode + "->return",
			"stored goal lookup failed and the upstream hook returns without marking a goal");
	}

	public static function missingGoal():ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true, "stored_goal_missing_skip", true, true, true, true, false, true,
			ThreadReadStoredGoalLookupOutcomeKind.Missing, false, "", "", false, false,
			"on_turn_start->start_turn:account_tokens=true->get_thread_goal/none->return", "no stored goal was available to mark active for this turn");
	}

	public static function nonActiveGoal(status:String):ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true, "stored_goal_not_active_skip", true, true, true, true, false, true,
			ThreadReadStoredGoalLookupOutcomeKind.Found, false, "", "", false, false,
			"on_turn_start->start_turn:account_tokens=true->get_thread_goal:" + status + "->return", "stored goal status is not active or budget-limited");
	}

	public static function markedActive(goalId:String, status:String, budgetLimitReportCleared:Bool):ThreadReadTurnStartGoalAccountingOutcome {
		return new ThreadReadTurnStartGoalAccountingOutcome(true,
			status == "budgetLimited" ? "budget_limited_goal_marked_active_for_turn" : "active_goal_marked_active_for_turn", true, true, true, true, false,
			true, ThreadReadStoredGoalLookupOutcomeKind.Found, true, goalId, goalId, budgetLimitReportCleared, false,
			"on_turn_start->start_turn:account_tokens=true->get_thread_goal:"
			+ status
			+ "->mark_turn_goal_active:"
			+ goalId,
			"stored goal was marked active for the current turn");
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";runtimeAvailable=" + (runtimeAvailable ? "true" : "false") + ";runtimeEnabled="
			+ (runtimeEnabled ? "true" : "false") + ";startTurn=" + (startTurnCalled ? "true" : "false") + ";accountTokens="
			+ (accountTokens ? "true" : "false") + ";clearCurrentTurnGoal=" + (clearCurrentTurnGoalCalled ? "true" : "false") + ";lookupAttempted="
			+ (storedGoalLookupAttempted ? "true" : "false") + ";lookupOutcome=" + storedGoalLookupOutcomeKind + ";markedActive="
			+ (storedGoalMarkedActive ? "true" : "false") + ";currentTurnGoalId=" + currentTurnGoalId + ";wallClockActiveGoalId=" + wallClockActiveGoalId
			+ ";budgetReportCleared=" + (budgetLimitReportCleared ? "true" : "false") + ";stateLookupError=" + (stateLookupError ? "true" : "false")
			+ ";sequence=" + sequence + ";message=" + message;
	}
}
