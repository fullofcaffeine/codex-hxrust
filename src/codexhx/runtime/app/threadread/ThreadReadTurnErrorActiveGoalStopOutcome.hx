package codexhx.runtime.app.threadread;

class ThreadReadTurnErrorActiveGoalStopOutcome {
	public final ok:Bool;
	public final code:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final errorKind:String;
	public final stopReason:String;
	public final targetStatus:String;
	public final progressEventId:String;
	public final statusEventId:String;
	public final goalStatePermitAttempted:Bool;
	public final goalStatePermitOk:Bool;
	public final currentTurnChecked:Bool;
	public final currentTurnIsActiveGoal:Bool;
	public final accountingAttempted:Bool;
	public final accountingOk:Bool;
	public final accountingCode:String;
	public final storedGoalLookupAttempted:Bool;
	public final storedGoalLookupOutcomeKind:String;
	public final statusUpdateAttempted:Bool;
	public final statusUpdated:Bool;
	public final previousStatus:String;
	public final finalStatus:String;
	public final activeGoalCleared:Bool;
	public final threadGoalUpdatedEmitted:Bool;
	public final terminalMetricRecorded:Bool;
	public final warningLogged:Bool;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		runtimeAvailable:Bool,
		runtimeEnabled:Bool,
		errorKind:String,
		stopReason:String,
		targetStatus:String,
		progressEventId:String,
		statusEventId:String,
		goalStatePermitAttempted:Bool,
		goalStatePermitOk:Bool,
		currentTurnChecked:Bool,
		currentTurnIsActiveGoal:Bool,
		accountingAttempted:Bool,
		accountingOk:Bool,
		accountingCode:String,
		storedGoalLookupAttempted:Bool,
		storedGoalLookupOutcomeKind:String,
		statusUpdateAttempted:Bool,
		statusUpdated:Bool,
		previousStatus:String,
		finalStatus:String,
		activeGoalCleared:Bool,
		threadGoalUpdatedEmitted:Bool,
		terminalMetricRecorded:Bool,
		warningLogged:Bool,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.errorKind = errorKind;
		this.stopReason = stopReason;
		this.targetStatus = targetStatus;
		this.progressEventId = progressEventId;
		this.statusEventId = statusEventId;
		this.goalStatePermitAttempted = goalStatePermitAttempted;
		this.goalStatePermitOk = goalStatePermitOk;
		this.currentTurnChecked = currentTurnChecked;
		this.currentTurnIsActiveGoal = currentTurnIsActiveGoal;
		this.accountingAttempted = accountingAttempted;
		this.accountingOk = accountingOk;
		this.accountingCode = accountingCode;
		this.storedGoalLookupAttempted = storedGoalLookupAttempted;
		this.storedGoalLookupOutcomeKind = storedGoalLookupOutcomeKind;
		this.statusUpdateAttempted = statusUpdateAttempted;
		this.statusUpdated = statusUpdated;
		this.previousStatus = previousStatus;
		this.finalStatus = finalStatus;
		this.activeGoalCleared = activeGoalCleared;
		this.threadGoalUpdatedEmitted = threadGoalUpdatedEmitted;
		this.terminalMetricRecorded = terminalMetricRecorded;
		this.warningLogged = warningLogged;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing(errorKind:String, reason:String, targetStatus:String):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"runtime_missing_skip",
			false,
			false,
			errorKind,
			reason,
			targetStatus,
			"",
			"",
			false,
			false,
			false,
			false,
			false,
			true,
			"",
			false,
			"none",
			false,
			false,
			"",
			"",
			false,
			false,
			false,
			false,
			"on_turn_error->goal_runtime_handle/none->return",
			"turn-error stop skipped because the goal runtime was unavailable"
		);
	}

	public static function runtimeDisabled(errorKind:String, reason:String, targetStatus:String):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"runtime_disabled_skip",
			true,
			false,
			errorKind,
			reason,
			targetStatus,
			"",
			"",
			false,
			false,
			false,
			false,
			false,
			true,
			"",
			false,
			"none",
			false,
			false,
			"",
			"",
			false,
			false,
			false,
			false,
			"on_turn_error->stop_active_goal_for_turn->runtime_disabled->return",
			"turn-error stop skipped because the goal runtime was disabled"
		);
	}

	public static function permitFailure(errorKind:String, reason:String, targetStatus:String):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"goal_state_permit_failed_warn",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			"",
			"",
			true,
			false,
			false,
			false,
			false,
			true,
			"",
			false,
			"none",
			false,
			false,
			"",
			"",
			false,
			false,
			false,
			true,
			"on_turn_error->stop_active_goal_for_turn->goal_state_permit/error->warn",
			"goal-state permit acquisition failed and on_turn_error logged a warning"
		);
	}

	public static function nonCurrent(errorKind:String, reason:String, targetStatus:String):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"current_turn_not_active_goal_noop",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			"",
			"",
			true,
			true,
			true,
			false,
			false,
			true,
			"",
			false,
			"none",
			false,
			false,
			"",
			"",
			false,
			false,
			false,
			false,
			"on_turn_error->stop_active_goal_for_turn->turn_is_current_active_goal/false->return",
			"turn was not the current active goal, so no stop side effects were applied"
		);
	}

	public static function accountingFailure(
		errorKind:String,
		reason:String,
		targetStatus:String,
		progressEventId:String,
		accountingCode:String
	):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"accounting_failed_warn",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			progressEventId,
			"",
			true,
			true,
			true,
			true,
			true,
			false,
			accountingCode,
			false,
			"none",
			false,
			false,
			"",
			"",
			false,
			false,
			false,
			true,
			"on_turn_error->stop_active_goal_for_turn->account_active_goal_progress:" + progressEventId + "/error:" + accountingCode + "->warn",
			"active goal progress accounting failed and on_turn_error logged a warning"
		);
	}

	public static function lookupFailure(
		errorKind:String,
		reason:String,
		targetStatus:String,
		progressEventId:String,
		accounting:ThreadReadActiveGoalProgressAccountingOutcome,
		errorCode:String
	):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"stored_goal_lookup_failed_warn",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			progressEventId,
			"",
			true,
			true,
			true,
			true,
			true,
			true,
			accounting.code,
			true,
			ThreadReadStoredGoalLookupOutcomeKind.Error,
			false,
			false,
			"",
			"",
			accounting.activeGoalCleared,
			false,
			false,
			true,
			"on_turn_error->stop_active_goal_for_turn->account_active_goal_progress:" + progressEventId + "/ok->get_thread_goal/error:" + errorCode + "->warn",
			"stored goal lookup failed after accounting and on_turn_error logged a warning"
		);
	}

	public static function missingStoredGoal(
		errorKind:String,
		reason:String,
		targetStatus:String,
		progressEventId:String,
		accounting:ThreadReadActiveGoalProgressAccountingOutcome
	):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"stored_goal_missing_clear_active",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			progressEventId,
			"",
			true,
			true,
			true,
			true,
			true,
			true,
			accounting.code,
			true,
			ThreadReadStoredGoalLookupOutcomeKind.Missing,
			false,
			false,
			"",
			"",
			true,
			false,
			false,
			false,
			"on_turn_error->stop_active_goal_for_turn->account_active_goal_progress:" + progressEventId + "/ok->get_thread_goal/none->clear_active_goal",
			"stored goal was missing after accounting, so active-goal accounting state was cleared"
		);
	}

	public static function notStoppable(
		errorKind:String,
		reason:String,
		targetStatus:String,
		progressEventId:String,
		accounting:ThreadReadActiveGoalProgressAccountingOutcome,
		previousStatus:String
	):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			"stored_goal_status_not_stoppable_clear_active",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			progressEventId,
			"",
			true,
			true,
			true,
			true,
			true,
			true,
			accounting.code,
			true,
			ThreadReadStoredGoalLookupOutcomeKind.Found,
			false,
			false,
			previousStatus,
			previousStatus,
			true,
			false,
			false,
			false,
			"on_turn_error->stop_active_goal_for_turn->account_active_goal_progress:" + progressEventId + "/ok->can_stop:false:" + previousStatus + "->clear_active_goal",
			"stored goal status could not be stopped by this reason"
		);
	}

	public static function stopped(
		errorKind:String,
		reason:String,
		targetStatus:String,
		progressEventId:String,
		statusEventId:String,
		accounting:ThreadReadActiveGoalProgressAccountingOutcome,
		previousStatus:String
	):ThreadReadTurnErrorActiveGoalStopOutcome {
		return base(
			reason == ThreadReadActiveGoalStopReason.UsageLimit ? "usage_limited_goal_stopped" : "turn_error_goal_blocked",
			true,
			true,
			errorKind,
			reason,
			targetStatus,
			progressEventId,
			statusEventId,
			true,
			true,
			true,
			true,
			true,
			true,
			accounting.code,
			true,
			ThreadReadStoredGoalLookupOutcomeKind.Found,
			true,
			true,
			previousStatus,
			targetStatus,
			true,
			true,
			previousStatus != targetStatus,
			false,
			"on_turn_error->stop_active_goal_for_turn->account_active_goal_progress:" + progressEventId + "/ok->update_thread_goal:" + targetStatus + "->thread_goal_updated:" + statusEventId,
			"active goal was stopped after a terminal turn error"
		);
	}

	static function base(
		code:String,
		runtimeAvailable:Bool,
		runtimeEnabled:Bool,
		errorKind:String,
		stopReason:String,
		targetStatus:String,
		progressEventId:String,
		statusEventId:String,
		goalStatePermitAttempted:Bool,
		goalStatePermitOk:Bool,
		currentTurnChecked:Bool,
		currentTurnIsActiveGoal:Bool,
		accountingAttempted:Bool,
		accountingOk:Bool,
		accountingCode:String,
		storedGoalLookupAttempted:Bool,
		storedGoalLookupOutcomeKind:String,
		statusUpdateAttempted:Bool,
		statusUpdated:Bool,
		previousStatus:String,
		finalStatus:String,
		activeGoalCleared:Bool,
		threadGoalUpdatedEmitted:Bool,
		terminalMetricRecorded:Bool,
		warningLogged:Bool,
		sequence:String,
		message:String
	):ThreadReadTurnErrorActiveGoalStopOutcome {
		return new ThreadReadTurnErrorActiveGoalStopOutcome(
			true,
			code,
			runtimeAvailable,
			runtimeEnabled,
			errorKind,
			stopReason,
			targetStatus,
			progressEventId,
			statusEventId,
			goalStatePermitAttempted,
			goalStatePermitOk,
			currentTurnChecked,
			currentTurnIsActiveGoal,
			accountingAttempted,
			accountingOk,
			accountingCode,
			storedGoalLookupAttempted,
			storedGoalLookupOutcomeKind,
			statusUpdateAttempted,
			statusUpdated,
			previousStatus,
			finalStatus,
			activeGoalCleared,
			threadGoalUpdatedEmitted,
			terminalMetricRecorded,
			warningLogged,
			sequence,
			message
		);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";runtimeAvailable=" + (runtimeAvailable ? "true" : "false")
			+ ";runtimeEnabled=" + (runtimeEnabled ? "true" : "false")
			+ ";errorKind=" + errorKind
			+ ";stopReason=" + stopReason
			+ ";targetStatus=" + targetStatus
			+ ";progressEventId=" + progressEventId
			+ ";statusEventId=" + statusEventId
			+ ";permitAttempted=" + (goalStatePermitAttempted ? "true" : "false")
			+ ";permitOk=" + (goalStatePermitOk ? "true" : "false")
			+ ";currentTurnChecked=" + (currentTurnChecked ? "true" : "false")
			+ ";currentTurnIsActiveGoal=" + (currentTurnIsActiveGoal ? "true" : "false")
			+ ";accountingAttempted=" + (accountingAttempted ? "true" : "false")
			+ ";accountingOk=" + (accountingOk ? "true" : "false")
			+ ";accountingCode=" + accountingCode
			+ ";lookupAttempted=" + (storedGoalLookupAttempted ? "true" : "false")
			+ ";lookupOutcome=" + storedGoalLookupOutcomeKind
			+ ";statusUpdateAttempted=" + (statusUpdateAttempted ? "true" : "false")
			+ ";statusUpdated=" + (statusUpdated ? "true" : "false")
			+ ";previousStatus=" + previousStatus
			+ ";finalStatus=" + finalStatus
			+ ";activeCleared=" + (activeGoalCleared ? "true" : "false")
			+ ";event=" + (threadGoalUpdatedEmitted ? "true" : "false")
			+ ";terminalMetric=" + (terminalMetricRecorded ? "true" : "false")
			+ ";warning=" + (warningLogged ? "true" : "false")
			+ ";sequence=" + sequence
			+ ";message=" + message;
	}
}
