package codexhx.runtime.app.threadread;

class ThreadReadToolFinishGoalProgressAdmissionOutcome {
	public final ok:Bool;
	public final code:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final turnId:String;
	public final callId:String;
	public final toolNamespace:String;
	public final toolName:String;
	public final outcomeKind:String;
	public final completedSuccess:Bool;
	public final failedHandlerExecuted:Bool;
	public final toolAttemptCounts:Bool;
	public final updateGoalSelfTool:Bool;
	public final admitted:Bool;
	public final accountingAttempted:Bool;
	public final accountingMode:String;
	public final budgetLimitedDisposition:String;
	public final accountingEventId:String;
	public final accountingOk:Bool;
	public final accountingCode:String;
	public final progressReturned:Bool;
	public final budgetLimitedProgress:Bool;
	public final warningLogged:Bool;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, runtimeAvailable:Bool, runtimeEnabled:Bool, turnId:String, callId:String, toolNamespace:String, toolName:String,
			outcomeKind:String, completedSuccess:Bool, failedHandlerExecuted:Bool, toolAttemptCounts:Bool, updateGoalSelfTool:Bool, admitted:Bool,
			accountingAttempted:Bool, accountingMode:String, budgetLimitedDisposition:String, accountingEventId:String, accountingOk:Bool,
			accountingCode:String, progressReturned:Bool, budgetLimitedProgress:Bool, warningLogged:Bool, sequence:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.turnId = turnId;
		this.callId = callId;
		this.toolNamespace = toolNamespace;
		this.toolName = toolName;
		this.outcomeKind = outcomeKind;
		this.completedSuccess = completedSuccess;
		this.failedHandlerExecuted = failedHandlerExecuted;
		this.toolAttemptCounts = toolAttemptCounts;
		this.updateGoalSelfTool = updateGoalSelfTool;
		this.admitted = admitted;
		this.accountingAttempted = accountingAttempted;
		this.accountingMode = accountingMode;
		this.budgetLimitedDisposition = budgetLimitedDisposition;
		this.accountingEventId = accountingEventId;
		this.accountingOk = accountingOk;
		this.accountingCode = accountingCode;
		this.progressReturned = progressReturned;
		this.budgetLimitedProgress = budgetLimitedProgress;
		this.warningLogged = warningLogged;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing(request:ThreadReadToolFinishGoalProgressAdmissionRequest):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return skipped("runtime_missing_skip", request, false, false, false, "on_tool_finish->goal_runtime_handle/none->return",
			"tool-finish goal progress skipped because the goal runtime was unavailable");
	}

	public static function runtimeDisabled(request:ThreadReadToolFinishGoalProgressAdmissionRequest, toolAttemptCounts:Bool,
			updateGoalSelfTool:Bool):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return skipped("runtime_disabled_skip", request, toolAttemptCounts, updateGoalSelfTool, false, "on_tool_finish->runtime_disabled->return",
			"tool-finish goal progress skipped because the goal runtime was disabled");
	}

	public static function outcomeNotCounted(request:ThreadReadToolFinishGoalProgressAdmissionRequest, toolAttemptCounts:Bool,
			updateGoalSelfTool:Bool):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return skipped("tool_outcome_not_counted_skip", request, toolAttemptCounts, updateGoalSelfTool, true,
			"on_tool_finish->tool_attempt_counts_for_goal_progress:" + request.outcomeKind + "/false->return",
			"tool outcome does not count toward goal progress");
	}

	public static function updateGoalSelfToolSkip(request:ThreadReadToolFinishGoalProgressAdmissionRequest,
			toolAttemptCounts:Bool):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return skipped("update_goal_self_tool_skip", request, toolAttemptCounts, true, true,
			"on_tool_finish->tool_attempt_counts_for_goal_progress:true->bare_update_goal->return",
			"bare update_goal tool calls do not count toward their own goal progress");
	}

	public static function accountingMissing(request:ThreadReadToolFinishGoalProgressAdmissionRequest):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return makeAdmitted("accounting_outcome_missing_warn", request, false, "accounting_outcome_missing", false, false, true,
			"on_tool_finish->account_active_goal_progress:" + request.callId + "/missing->warn->return",
			"admitted tool finish had no accounting outcome and logged warning evidence");
	}

	public static function accountingFailed(request:ThreadReadToolFinishGoalProgressAdmissionRequest,
			accountingCode:String):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return makeAdmitted("accounting_failed_warn", request, false, accountingCode, false, false, true,
			"on_tool_finish->account_active_goal_progress:"
			+ request.callId
			+ "/error:"
			+ accountingCode
			+ "->warn->return",
			"active goal progress accounting failed after tool finish");
	}

	public static function noProgress(request:ThreadReadToolFinishGoalProgressAdmissionRequest,
			accountingCode:String):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return makeAdmitted("admitted_no_active_progress", request, true, accountingCode, false, false, false,
			"on_tool_finish->account_active_goal_progress:" + request.callId + "/ok:none->return",
			"tool finish was admitted but no active goal progress was available");
	}

	public static function progressReturnedOutcome(request:ThreadReadToolFinishGoalProgressAdmissionRequest, accountingCode:String,
			budgetLimitedProgress:Bool):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return makeAdmitted(budgetLimitedProgress ? "admitted_budget_limited_progress" : "admitted_progress", request, true, accountingCode, true,
			budgetLimitedProgress, false,
			"on_tool_finish->account_active_goal_progress:"
			+ request.callId
			+ "/ok:progress->"
			+ (budgetLimitedProgress ? "budget_limit_steering_boundary" : "not_budget_limited->return"),
			budgetLimitedProgress ? "tool finish was admitted and returned budget-limited progress" : "tool finish was admitted and returned non-budget progress");
	}

	static function skipped(code:String, request:ThreadReadToolFinishGoalProgressAdmissionRequest, toolAttemptCounts:Bool, updateGoalSelfTool:Bool,
			runtimeEnabled:Bool, sequence:String, message:String):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return new ThreadReadToolFinishGoalProgressAdmissionOutcome(true, code, request.runtimeAvailable, runtimeEnabled, request.turnId, request.callId,
			request.toolNamespace, request.toolName, request.outcomeKind, request.completedSuccess, request.failedHandlerExecuted, toolAttemptCounts,
			updateGoalSelfTool, false, false, "none", "none", "", true, "", false, false, false, sequence, message);
	}

	static function makeAdmitted(code:String, request:ThreadReadToolFinishGoalProgressAdmissionRequest, accountingOk:Bool, accountingCode:String,
			progressReturned:Bool, budgetLimitedProgress:Bool, warningLogged:Bool, sequence:String,
			message:String):ThreadReadToolFinishGoalProgressAdmissionOutcome {
		return new ThreadReadToolFinishGoalProgressAdmissionOutcome(true, code, true, true, request.turnId, request.callId, request.toolNamespace,
			request.toolName, request.outcomeKind, request.completedSuccess, request.failedHandlerExecuted, true, false, true, true, "active_only",
			ThreadReadGoalAccountingDisposition.KeepActive, request.callId, accountingOk, accountingCode, progressReturned, budgetLimitedProgress,
			warningLogged, sequence, message);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";runtimeAvailable=" + (runtimeAvailable ? "true" : "false") + ";runtimeEnabled="
			+ (runtimeEnabled ? "true" : "false") + ";turnId=" + turnId + ";callId=" + callId + ";toolNamespace=" + toolNamespace + ";toolName=" + toolName
			+ ";outcome=" + outcomeKind + ";completedSuccess=" + (completedSuccess ? "true" : "false") + ";failedHandlerExecuted="
			+ (failedHandlerExecuted ? "true" : "false") + ";toolAttemptCounts=" + (toolAttemptCounts ? "true" : "false") + ";updateGoalSelfTool="
			+ (updateGoalSelfTool ? "true" : "false") + ";admitted=" + (admitted ? "true" : "false") + ";accountingAttempted="
			+ (accountingAttempted ? "true" : "false") + ";mode=" + accountingMode + ";disposition=" + budgetLimitedDisposition + ";eventId="
			+ accountingEventId + ";accountingOk=" + (accountingOk ? "true" : "false") + ";accountingCode=" + accountingCode + ";progressReturned="
			+ (progressReturned ? "true" : "false") + ";budgetLimitedProgress=" + (budgetLimitedProgress ? "true" : "false") + ";warning="
			+ (warningLogged ? "true" : "false") + ";sequence=" + sequence + ";message=" + message;
	}
}
