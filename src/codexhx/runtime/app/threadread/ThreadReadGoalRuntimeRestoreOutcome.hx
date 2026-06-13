package codexhx.runtime.app.threadread;

class ThreadReadGoalRuntimeRestoreOutcome {
	public final ok:Bool;
	public final code:String;
	public final runtimePresent:Bool;
	public final runtimeEnabled:Bool;
	public final stateReadAttempted:Bool;
	public final restoredActiveGoal:Bool;
	public final clearedActiveGoal:Bool;
	public final resumedMetricRecorded:Bool;
	public final idleAccountingActive:Bool;
	public final previousActiveGoalId:String;
	public final activeGoalIdAfter:String;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		runtimePresent:Bool,
		runtimeEnabled:Bool,
		stateReadAttempted:Bool,
		restoredActiveGoal:Bool,
		clearedActiveGoal:Bool,
		resumedMetricRecorded:Bool,
		idleAccountingActive:Bool,
		previousActiveGoalId:String,
		activeGoalIdAfter:String,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.runtimePresent = runtimePresent;
		this.runtimeEnabled = runtimeEnabled;
		this.stateReadAttempted = stateReadAttempted;
		this.restoredActiveGoal = restoredActiveGoal;
		this.clearedActiveGoal = clearedActiveGoal;
		this.resumedMetricRecorded = resumedMetricRecorded;
		this.idleAccountingActive = idleAccountingActive;
		this.previousActiveGoalId = previousActiveGoalId;
		this.activeGoalIdAfter = activeGoalIdAfter;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing():ThreadReadGoalRuntimeRestoreOutcome {
		return new ThreadReadGoalRuntimeRestoreOutcome(
			true,
			"runtime_missing_skip",
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			"",
			"",
			"thread/resume->goal/runtime/missing->skip",
			"thread resume has no goal runtime in extension data"
		);
	}

	public static function disabled(previousActiveGoalId:String):ThreadReadGoalRuntimeRestoreOutcome {
		return new ThreadReadGoalRuntimeRestoreOutcome(
			true,
			"runtime_disabled_noop",
			true,
			false,
			false,
			false,
			false,
			false,
			previousActiveGoalId.length > 0,
			previousActiveGoalId,
			previousActiveGoalId,
			"thread/resume->goal/runtime/restore->disabled/noop",
			"disabled goal runtime returns Ok without reading goal state"
		);
	}

	public static function restored(previousActiveGoalId:String, activeGoalIdAfter:String):ThreadReadGoalRuntimeRestoreOutcome {
		return new ThreadReadGoalRuntimeRestoreOutcome(
			true,
			"active_goal_restored",
			true,
			true,
			true,
			true,
			false,
			true,
			true,
			previousActiveGoalId,
			activeGoalIdAfter,
			"thread/resume->goal/runtime/restore->state/read->accounting/mark_idle_goal_active->metrics/resumed",
			"stored active goal rehydrates idle accounting and records resumed metric"
		);
	}

	public static function cleared(code:String, previousActiveGoalId:String, message:String):ThreadReadGoalRuntimeRestoreOutcome {
		return new ThreadReadGoalRuntimeRestoreOutcome(
			true,
			code,
			true,
			true,
			true,
			false,
			true,
			false,
			false,
			previousActiveGoalId,
			"",
			"thread/resume->goal/runtime/restore->state/read->accounting/clear_active_goal",
			message
		);
	}

	public static function failure(previousActiveGoalId:String, errorCode:String):ThreadReadGoalRuntimeRestoreOutcome {
		return new ThreadReadGoalRuntimeRestoreOutcome(
			false,
			"state_read_failed",
			true,
			true,
			true,
			false,
			false,
			false,
			previousActiveGoalId.length > 0,
			previousActiveGoalId,
			previousActiveGoalId,
			"thread/resume->goal/runtime/restore->state/read/error",
			"failed to restore goal runtime after thread resume: " + errorCode
		);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";runtimePresent=" + (runtimePresent ? "true" : "false")
			+ ";runtimeEnabled=" + (runtimeEnabled ? "true" : "false")
			+ ";stateReadAttempted=" + (stateReadAttempted ? "true" : "false")
			+ ";restoredActiveGoal=" + (restoredActiveGoal ? "true" : "false")
			+ ";clearedActiveGoal=" + (clearedActiveGoal ? "true" : "false")
			+ ";resumedMetricRecorded=" + (resumedMetricRecorded ? "true" : "false")
			+ ";idleAccountingActive=" + (idleAccountingActive ? "true" : "false")
			+ ";previousActiveGoalId=" + (previousActiveGoalId.length == 0 ? "none" : previousActiveGoalId)
			+ ";activeGoalIdAfter=" + (activeGoalIdAfter.length == 0 ? "none" : activeGoalIdAfter)
			+ ";sequence=" + sequence
			+ ";message=" + message;
	}
}
