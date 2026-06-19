package codexhx.runtime.app.threadread;

class ThreadReadIdleGoalProgressAccountingOutcome {
	public final ok:Bool;
	public final code:String;
	public final idleProgressSnapshotAvailable:Bool;
	public final dbCallAttempted:Bool;
	public final dbOutcomeKind:String;
	public final progressUpdated:Bool;
	public final progressReturned:Bool;
	public final goalId:String;
	public final status:String;
	public final wallClockAccountedSeconds:Int;
	public final tokenDeltaAccounted:Int;
	public final activeGoalCleared:Bool;
	public final idleBaselineReset:Bool;
	public final budgetLimitReportCleared:Bool;
	public final threadGoalUpdatedEmitted:Bool;
	public final emittedTurnId:String;
	public final terminalMetricRecorded:Bool;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, idleProgressSnapshotAvailable:Bool, dbCallAttempted:Bool, dbOutcomeKind:String, progressUpdated:Bool,
			progressReturned:Bool, goalId:String, status:String, wallClockAccountedSeconds:Int, tokenDeltaAccounted:Int, activeGoalCleared:Bool,
			idleBaselineReset:Bool, budgetLimitReportCleared:Bool, threadGoalUpdatedEmitted:Bool, emittedTurnId:String, terminalMetricRecorded:Bool,
			sequence:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.idleProgressSnapshotAvailable = idleProgressSnapshotAvailable;
		this.dbCallAttempted = dbCallAttempted;
		this.dbOutcomeKind = dbOutcomeKind;
		this.progressUpdated = progressUpdated;
		this.progressReturned = progressReturned;
		this.goalId = goalId;
		this.status = status;
		this.wallClockAccountedSeconds = wallClockAccountedSeconds;
		this.tokenDeltaAccounted = tokenDeltaAccounted;
		this.activeGoalCleared = activeGoalCleared;
		this.idleBaselineReset = idleBaselineReset;
		this.budgetLimitReportCleared = budgetLimitReportCleared;
		this.threadGoalUpdatedEmitted = threadGoalUpdatedEmitted;
		this.emittedTurnId = emittedTurnId;
		this.terminalMetricRecorded = terminalMetricRecorded;
		this.sequence = sequence;
		this.message = message;
	}

	public static function missingSnapshot():ThreadReadIdleGoalProgressAccountingOutcome {
		return new ThreadReadIdleGoalProgressAccountingOutcome(true, "idle_progress_snapshot_missing", false, false, "none", false, false, "", "", 0, 0,
			false, false, false, false, "", false, "account_idle_goal_progress->idle_progress_snapshot/none->return_none",
			"no idle goal progress snapshot was available");
	}

	public static function stateError(kind:String, code:String):ThreadReadIdleGoalProgressAccountingOutcome {
		return new ThreadReadIdleGoalProgressAccountingOutcome(false, "state_accounting_failed", true, true, kind, false, false, "", "", 0, 0, false, false,
			false, false, "", false, "account_idle_goal_progress->idle_progress_snapshot->account_thread_goal_usage/error:" + code,
			"state DB idle goal usage accounting failed: " + code);
	}

	public static function unchanged(expectedGoalId:String):ThreadReadIdleGoalProgressAccountingOutcome {
		return new ThreadReadIdleGoalProgressAccountingOutcome(true, "state_accounting_unchanged_idle_reset", true, true,
			ThreadReadGoalAccountingDbOutcomeKind.Unchanged, false, false, expectedGoalId, "", 0, 0, true, true, true, false, "", false,
			"account_idle_goal_progress->idle_progress_snapshot:" + expectedGoalId +
			"->account_thread_goal_usage/unchanged->reset_idle_progress_baseline_and_clear_active_goal->return_none",
			"state DB reported no goal update; idle accounting baseline was reset and active goal cleared");
	}

	public static function updated(code:String, goalId:String, status:String, timeDeltaSeconds:Int, activeGoalCleared:Bool, budgetLimitReportCleared:Bool,
			terminalMetricRecorded:Bool, disposition:String):ThreadReadIdleGoalProgressAccountingOutcome {
		return new ThreadReadIdleGoalProgressAccountingOutcome(true, code, true, true, ThreadReadGoalAccountingDbOutcomeKind.Updated, true, true, goalId,
			status, timeDeltaSeconds, 0, activeGoalCleared, false, budgetLimitReportCleared, true, "", terminalMetricRecorded,
			"account_idle_goal_progress->idle_progress_snapshot:"
			+ goalId
			+ "->account_thread_goal_usage/updated:token_delta=0"
			+ "->mark_idle_progress_accounted_for_status:"
			+ status
			+ "/"
			+ disposition
			+ "->thread_goal_updated:turn_id=none",
			"idle goal progress was accounted and emitted");
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";snapshot=" + (idleProgressSnapshotAvailable ? "true" : "false") + ";dbCall="
			+ (dbCallAttempted ? "true" : "false") + ";dbOutcome=" + dbOutcomeKind + ";updated=" + (progressUpdated ? "true" : "false") + ";returned="
			+ (progressReturned ? "true" : "false") + ";goalId=" + goalId + ";status=" + status + ";seconds=" + Std.string(wallClockAccountedSeconds)
			+ ";tokens=" + Std.string(tokenDeltaAccounted) + ";activeCleared=" + (activeGoalCleared ? "true" : "false") + ";idleBaselineReset="
			+ (idleBaselineReset ? "true" : "false") + ";budgetReportCleared=" + (budgetLimitReportCleared ? "true" : "false") + ";event="
			+ (threadGoalUpdatedEmitted ? "true" : "false") + ";emittedTurnId=" + emittedTurnId + ";terminalMetric="
			+ (terminalMetricRecorded ? "true" : "false") + ";sequence=" + sequence + ";message=" + message;
	}
}
