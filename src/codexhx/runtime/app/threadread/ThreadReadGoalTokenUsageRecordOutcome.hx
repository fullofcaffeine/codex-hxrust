package codexhx.runtime.app.threadread;

class ThreadReadGoalTokenUsageRecordOutcome {
	public final ok:Bool;
	public final code:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final turnStoreLevelId:String;
	public final currentTurnId:String;
	public final recordAttempted:Bool;
	public final turnKnown:Bool;
	public final accountTokens:Bool;
	public final currentUsageUpdated:Bool;
	public final recorded:Bool;
	public final turnDelta:Int;
	public final threadUnflushedDelta:Int;
	public final goalChargeDelta:Int;
	public final ignoredReasoningOutputTokens:Bool;
	public final ignoredTotalTokens:Bool;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, runtimeAvailable:Bool, runtimeEnabled:Bool, turnStoreLevelId:String, currentTurnId:String, recordAttempted:Bool,
			turnKnown:Bool, accountTokens:Bool, currentUsageUpdated:Bool, recorded:Bool, turnDelta:Int, threadUnflushedDelta:Int, goalChargeDelta:Int,
			ignoredReasoningOutputTokens:Bool, ignoredTotalTokens:Bool, sequence:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.turnStoreLevelId = turnStoreLevelId;
		this.currentTurnId = currentTurnId;
		this.recordAttempted = recordAttempted;
		this.turnKnown = turnKnown;
		this.accountTokens = accountTokens;
		this.currentUsageUpdated = currentUsageUpdated;
		this.recorded = recorded;
		this.turnDelta = turnDelta;
		this.threadUnflushedDelta = threadUnflushedDelta;
		this.goalChargeDelta = goalChargeDelta;
		this.ignoredReasoningOutputTokens = ignoredReasoningOutputTokens;
		this.ignoredTotalTokens = ignoredTotalTokens;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing(turnStoreLevelId:String, currentTurnId:String):ThreadReadGoalTokenUsageRecordOutcome {
		return new ThreadReadGoalTokenUsageRecordOutcome(true, "runtime_missing_skip", false, false, turnStoreLevelId, currentTurnId, false, false, false,
			false, false, 0, 0, 0, false, false, "on_token_usage->goal_runtime_handle/none->return",
			"token usage contribution skipped because the goal runtime was unavailable");
	}

	public static function runtimeDisabled(turnStoreLevelId:String, currentTurnId:String):ThreadReadGoalTokenUsageRecordOutcome {
		return new ThreadReadGoalTokenUsageRecordOutcome(true, "runtime_disabled_skip", true, false, turnStoreLevelId, currentTurnId, false, false, false,
			false, false, 0, 0, 0, false, false, "on_token_usage->runtime_disabled->return",
			"token usage contribution skipped because the goal runtime was disabled");
	}

	public static function unknownTurn(turnStoreLevelId:String, currentTurnId:String):ThreadReadGoalTokenUsageRecordOutcome {
		return new ThreadReadGoalTokenUsageRecordOutcome(true, "turn_unknown_skip", true, true, turnStoreLevelId, currentTurnId, true, false, false, false,
			false, 0, 0, 0, false, false, "on_token_usage->record_token_usage:" + turnStoreLevelId + "->turns.get_mut/none->return_none",
			"token usage contribution skipped because no accounting record exists for the turn");
	}

	public static function notAccounted(code:String, turnStoreLevelId:String, currentTurnId:String, accountTokens:Bool, goalChargeDelta:Int,
			ignoredReasoningOutputTokens:Bool, ignoredTotalTokens:Bool):ThreadReadGoalTokenUsageRecordOutcome {
		final reason = accountTokens ? "non_positive_delta" : "account_tokens_false";
		return new ThreadReadGoalTokenUsageRecordOutcome(true, code, true, true, turnStoreLevelId, currentTurnId, true, true, accountTokens, true, false, 0,
			0, goalChargeDelta, ignoredReasoningOutputTokens, ignoredTotalTokens,
			"on_token_usage->record_token_usage:"
			+ turnStoreLevelId
			+ "->current_token_usage=total->"
			+ reason
			+ "->return_none",
			accountTokens ? "token usage was updated but no positive goal delta was recorded" : "token usage was updated but token accounting is disabled for this turn");
	}

	public static function recordedDelta(turnStoreLevelId:String, currentTurnId:String, turnDelta:Int, threadUnflushedDelta:Int,
			ignoredReasoningOutputTokens:Bool, ignoredTotalTokens:Bool):ThreadReadGoalTokenUsageRecordOutcome {
		return new ThreadReadGoalTokenUsageRecordOutcome(true, "token_usage_recorded", true, true, turnStoreLevelId, currentTurnId, true, true, true, true,
			true, turnDelta, threadUnflushedDelta, turnDelta, ignoredReasoningOutputTokens, ignoredTotalTokens,
			"on_token_usage->record_token_usage:"
			+ turnStoreLevelId
			+ "->current_token_usage=total->RecordedTokenDelta(turn_delta="
			+ Std.string(turnDelta)
			+ ",thread_unflushed_delta="
			+ Std.string(threadUnflushedDelta)
			+ ")",
			"token usage was recorded for goal accounting");
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";runtimeAvailable=" + (runtimeAvailable ? "true" : "false") + ";runtimeEnabled="
			+ (runtimeEnabled ? "true" : "false") + ";turnStoreLevelId=" + turnStoreLevelId + ";currentTurnId=" + currentTurnId + ";recordAttempted="
			+ (recordAttempted ? "true" : "false") + ";turnKnown=" + (turnKnown ? "true" : "false") + ";accountTokens=" + (accountTokens ? "true" : "false")
			+ ";currentUsageUpdated=" + (currentUsageUpdated ? "true" : "false") + ";recorded=" + (recorded ? "true" : "false") + ";turnDelta="
			+ Std.string(turnDelta) + ";threadUnflushedDelta=" + Std.string(threadUnflushedDelta) + ";goalChargeDelta=" + Std.string(goalChargeDelta)
			+ ";ignoredReasoning=" + (ignoredReasoningOutputTokens ? "true" : "false") + ";ignoredTotal=" + (ignoredTotalTokens ? "true" : "false")
			+ ";sequence=" + sequence + ";message=" + message;
	}
}
