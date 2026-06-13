package codexhx.runtime.app.threadread;

class ThreadReadTurnGoalFinalizationOutcome {
	public final ok:Bool;
	public final code:String;
	public final kind:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final accountingAttempted:Bool;
	public final accountingMode:String;
	public final budgetLimitedDisposition:String;
	public final eventId:String;
	public final accountingOk:Bool;
	public final accountingCode:String;
	public final progressReturned:Bool;
	public final activeGoalCleared:Bool;
	public final finishTurnCalled:Bool;
	public final turnStatePreserved:Bool;
	public final warningLogged:Bool;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		kind:String,
		runtimeAvailable:Bool,
		runtimeEnabled:Bool,
		accountingAttempted:Bool,
		accountingMode:String,
		budgetLimitedDisposition:String,
		eventId:String,
		accountingOk:Bool,
		accountingCode:String,
		progressReturned:Bool,
		activeGoalCleared:Bool,
		finishTurnCalled:Bool,
		turnStatePreserved:Bool,
		warningLogged:Bool,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.kind = kind;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.accountingAttempted = accountingAttempted;
		this.accountingMode = accountingMode;
		this.budgetLimitedDisposition = budgetLimitedDisposition;
		this.eventId = eventId;
		this.accountingOk = accountingOk;
		this.accountingCode = accountingCode;
		this.progressReturned = progressReturned;
		this.activeGoalCleared = activeGoalCleared;
		this.finishTurnCalled = finishTurnCalled;
		this.turnStatePreserved = turnStatePreserved;
		this.warningLogged = warningLogged;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing(kind:String):ThreadReadTurnGoalFinalizationOutcome {
		return new ThreadReadTurnGoalFinalizationOutcome(
			true,
			"runtime_missing_skip",
			kind,
			false,
			false,
			false,
			"none",
			"none",
			"",
			true,
			"",
			false,
			false,
			false,
			true,
			false,
			hookName(kind) + "->goal_runtime_handle/none->return",
			"turn finalization skipped because the goal runtime was unavailable"
		);
	}

	public static function runtimeDisabled(kind:String):ThreadReadTurnGoalFinalizationOutcome {
		return new ThreadReadTurnGoalFinalizationOutcome(
			true,
			"runtime_disabled_skip",
			kind,
			true,
			false,
			false,
			"none",
			"none",
			"",
			true,
			"",
			false,
			false,
			false,
			true,
			false,
			hookName(kind) + "->runtime_disabled->return",
			"turn finalization skipped because the goal runtime was disabled"
		);
	}

	public static function accountingError(kind:String, eventId:String, accountingCode:String):ThreadReadTurnGoalFinalizationOutcome {
		return new ThreadReadTurnGoalFinalizationOutcome(
			true,
			"accounting_error_preserved_turn",
			kind,
			true,
			true,
			true,
			"active_only",
			ThreadReadGoalAccountingDisposition.ClearActive,
			eventId,
			false,
			accountingCode,
			false,
			false,
			false,
			true,
			true,
			hookName(kind) + "->account_active_goal_progress:" + eventId + "/error:" + accountingCode + "->warn->return",
			"active goal progress accounting failed and finish_turn was skipped"
		);
	}

	public static function finalized(
		kind:String,
		eventId:String,
		accounting:ThreadReadActiveGoalProgressAccountingOutcome
	):ThreadReadTurnGoalFinalizationOutcome {
		final suffix = accounting.progressReturned ? "with_progress" : "without_progress";
		return new ThreadReadTurnGoalFinalizationOutcome(
			true,
			kind + "_finalized_" + suffix,
			kind,
			true,
			true,
			true,
			"active_only",
			ThreadReadGoalAccountingDisposition.ClearActive,
			eventId,
			true,
			accounting.code,
			accounting.progressReturned,
			accounting.activeGoalCleared,
			true,
			false,
			false,
			hookName(kind) + "->account_active_goal_progress:" + eventId + "/ok:" + accounting.code + "->finish_turn",
			"active goal progress accounting completed and finish_turn removed the turn"
		);
	}

	static function hookName(kind:String):String {
		return kind == ThreadReadTurnGoalFinalizationKind.TurnAbort ? "on_turn_abort" : "on_turn_stop";
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";kind=" + kind
			+ ";runtimeAvailable=" + (runtimeAvailable ? "true" : "false")
			+ ";runtimeEnabled=" + (runtimeEnabled ? "true" : "false")
			+ ";accountingAttempted=" + (accountingAttempted ? "true" : "false")
			+ ";mode=" + accountingMode
			+ ";disposition=" + budgetLimitedDisposition
			+ ";eventId=" + eventId
			+ ";accountingOk=" + (accountingOk ? "true" : "false")
			+ ";accountingCode=" + accountingCode
			+ ";progressReturned=" + (progressReturned ? "true" : "false")
			+ ";activeCleared=" + (activeGoalCleared ? "true" : "false")
			+ ";finishTurn=" + (finishTurnCalled ? "true" : "false")
			+ ";turnPreserved=" + (turnStatePreserved ? "true" : "false")
			+ ";warning=" + (warningLogged ? "true" : "false")
			+ ";sequence=" + sequence
			+ ";message=" + message;
	}
}
