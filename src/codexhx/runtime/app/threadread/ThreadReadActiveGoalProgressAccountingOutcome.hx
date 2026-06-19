package codexhx.runtime.app.threadread;

class ThreadReadActiveGoalProgressAccountingOutcome {
	public final ok:Bool;
	public final code:String;
	public final progressSnapshotAvailable:Bool;
	public final dbCallAttempted:Bool;
	public final dbOutcomeKind:String;
	public final progressUpdated:Bool;
	public final progressReturned:Bool;
	public final goalId:String;
	public final status:String;
	public final turnLastUsageUpdated:Bool;
	public final wallClockAccountedSeconds:Int;
	public final tokenDeltaAccounted:Int;
	public final activeGoalCleared:Bool;
	public final budgetLimitReportCleared:Bool;
	public final threadGoalUpdatedEmitted:Bool;
	public final terminalMetricRecorded:Bool;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, progressSnapshotAvailable:Bool, dbCallAttempted:Bool, dbOutcomeKind:String, progressUpdated:Bool,
			progressReturned:Bool, goalId:String, status:String, turnLastUsageUpdated:Bool, wallClockAccountedSeconds:Int, tokenDeltaAccounted:Int,
			activeGoalCleared:Bool, budgetLimitReportCleared:Bool, threadGoalUpdatedEmitted:Bool, terminalMetricRecorded:Bool, sequence:String,
			message:String) {
		this.ok = ok;
		this.code = code;
		this.progressSnapshotAvailable = progressSnapshotAvailable;
		this.dbCallAttempted = dbCallAttempted;
		this.dbOutcomeKind = dbOutcomeKind;
		this.progressUpdated = progressUpdated;
		this.progressReturned = progressReturned;
		this.goalId = goalId;
		this.status = status;
		this.turnLastUsageUpdated = turnLastUsageUpdated;
		this.wallClockAccountedSeconds = wallClockAccountedSeconds;
		this.tokenDeltaAccounted = tokenDeltaAccounted;
		this.activeGoalCleared = activeGoalCleared;
		this.budgetLimitReportCleared = budgetLimitReportCleared;
		this.threadGoalUpdatedEmitted = threadGoalUpdatedEmitted;
		this.terminalMetricRecorded = terminalMetricRecorded;
		this.sequence = sequence;
		this.message = message;
	}

	public static function missingSnapshot(turnId:String):ThreadReadActiveGoalProgressAccountingOutcome {
		return new ThreadReadActiveGoalProgressAccountingOutcome(true, "progress_snapshot_missing", false, false, "none", false, false, "", "", false, 0, 0,
			false, false, false, false, "account_active_goal_progress:" + turnId + "->progress_snapshot/none->return_none",
			"no active goal progress snapshot was available");
	}

	public static function stateError(kind:String, code:String):ThreadReadActiveGoalProgressAccountingOutcome {
		return new ThreadReadActiveGoalProgressAccountingOutcome(false, "state_accounting_failed", true, true, kind, false, false, "", "", false, 0, 0, false,
			false, false, false, "account_active_goal_progress->progress_snapshot->account_thread_goal_usage/error:" + code,
			"state DB goal usage accounting failed: " + code);
	}

	public static function unchanged(expectedGoalId:String):ThreadReadActiveGoalProgressAccountingOutcome {
		return new ThreadReadActiveGoalProgressAccountingOutcome(true, "state_accounting_unchanged", true, true,
			ThreadReadGoalAccountingDbOutcomeKind.Unchanged, false, false, expectedGoalId, "", false, 0, 0, false, false, false, false,
			"account_active_goal_progress->progress_snapshot:" + expectedGoalId + "->account_thread_goal_usage/unchanged->return_none",
			"state DB reported no goal update");
	}

	public static function updated(code:String, goalId:String, status:String, timeDeltaSeconds:Int, tokenDelta:Int, activeGoalCleared:Bool,
			budgetLimitReportCleared:Bool, terminalMetricRecorded:Bool, disposition:String):ThreadReadActiveGoalProgressAccountingOutcome {
		return new ThreadReadActiveGoalProgressAccountingOutcome(true, code, true, true, ThreadReadGoalAccountingDbOutcomeKind.Updated, true, true, goalId,
			status, true, timeDeltaSeconds, tokenDelta, activeGoalCleared, budgetLimitReportCleared, true, terminalMetricRecorded,
			"account_active_goal_progress->progress_snapshot:"
			+ goalId
			+ "->account_thread_goal_usage/updated"
			+ "->mark_progress_accounted_for_status:"
			+ status
			+ "/"
			+ disposition
			+ "->thread_goal_updated",
			"active goal progress was accounted and emitted");
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";snapshot=" + (progressSnapshotAvailable ? "true" : "false") + ";dbCall="
			+ (dbCallAttempted ? "true" : "false") + ";dbOutcome=" + dbOutcomeKind + ";updated=" + (progressUpdated ? "true" : "false") + ";returned="
			+ (progressReturned ? "true" : "false") + ";goalId=" + goalId + ";status=" + status + ";usageMarked=" + (turnLastUsageUpdated ? "true" : "false")
			+ ";seconds=" + Std.string(wallClockAccountedSeconds) + ";tokens=" + Std.string(tokenDeltaAccounted) + ";activeCleared="
			+ (activeGoalCleared ? "true" : "false") + ";budgetReportCleared=" + (budgetLimitReportCleared ? "true" : "false") + ";event="
			+ (threadGoalUpdatedEmitted ? "true" : "false") + ";terminalMetric=" + (terminalMetricRecorded ? "true" : "false") + ";sequence=" + sequence
			+ ";message=" + message;
	}
}
