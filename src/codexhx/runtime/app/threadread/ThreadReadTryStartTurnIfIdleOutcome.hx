package codexhx.runtime.app.threadread;

class ThreadReadTryStartTurnIfIdleOutcome {
	public final ok:Bool;
	public final code:String;
	public final accepted:Bool;
	public final rejected:Bool;
	public final reason:ThreadReadTryStartTurnIfIdleRejectionReason;
	public final reservationCreated:Bool;
	public final reservationCleared:Bool;
	public final pendingInputInjected:Bool;
	public final regularTaskStarted:Bool;
	public final returnedItemUnchanged:Bool;
	public final returnedItemSummary:String;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, accepted:Bool, rejected:Bool, reason:ThreadReadTryStartTurnIfIdleRejectionReason, reservationCreated:Bool,
			reservationCleared:Bool, pendingInputInjected:Bool, regularTaskStarted:Bool, returnedItemUnchanged:Bool, returnedItemSummary:String,
			sequence:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.accepted = accepted;
		this.rejected = rejected;
		this.reason = reason;
		this.reservationCreated = reservationCreated;
		this.reservationCleared = reservationCleared;
		this.pendingInputInjected = pendingInputInjected;
		this.regularTaskStarted = regularTaskStarted;
		this.returnedItemUnchanged = returnedItemUnchanged;
		this.returnedItemSummary = returnedItemSummary;
		this.sequence = sequence;
		this.message = message;
	}

	public static function makeAccepted(returnedItemSummary:String):ThreadReadTryStartTurnIfIdleOutcome {
		return new ThreadReadTryStartTurnIfIdleOutcome(true, "accepted_regular_turn_started", true, false, ThreadReadTryStartTurnIfIdleRejectionReason.None,
			true, false, true, true, false, returnedItemSummary, "steering/item->idle/reserve->pending/input/extend->regular/task/start",
			"automatic idle work accepted and started as a regular task");
	}

	public static function makeEmptyInputNoop():ThreadReadTryStartTurnIfIdleOutcome {
		return new ThreadReadTryStartTurnIfIdleOutcome(true, "empty_input_noop", false, false, ThreadReadTryStartTurnIfIdleRejectionReason.None, false, false,
			false, false, false, "item=none", "input/empty->ok", "empty input returns Ok without reserving a turn");
	}

	public static function makeRejected(reason:ThreadReadTryStartTurnIfIdleRejectionReason, reservationCreated:Bool, returnedItemSummary:String,
			message:String):ThreadReadTryStartTurnIfIdleOutcome {
		final code = "rejected_" + reason;
		final sequence = reservationCreated ? "steering/item->idle/reserve->idle/reservation/clear->reject:" + reason : "steering/item->reject:" + reason;
		return new ThreadReadTryStartTurnIfIdleOutcome(true, code, false, true, reason, reservationCreated, reservationCreated, false, false, true,
			returnedItemSummary, sequence, message);
	}

	public static function failure(code:String, returnedItemSummary:String, message:String):ThreadReadTryStartTurnIfIdleOutcome {
		return new ThreadReadTryStartTurnIfIdleOutcome(false, code, false, false, ThreadReadTryStartTurnIfIdleRejectionReason.None, false, false, false,
			false, false, returnedItemSummary, "steering/item->failure", message);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";accepted=" + (accepted ? "true" : "false") + ";rejected="
			+ (rejected ? "true" : "false") + ";reason=" + reason + ";reservationCreated=" + (reservationCreated ? "true" : "false") + ";reservationCleared="
			+ (reservationCleared ? "true" : "false") + ";pendingInputInjected=" + (pendingInputInjected ? "true" : "false") + ";regularTaskStarted="
			+ (regularTaskStarted ? "true" : "false") + ";returnedItemUnchanged=" + (returnedItemUnchanged ? "true" : "false") + ";returnedItemSummary="
			+ returnedItemSummary + ";sequence=" + sequence + ";message=" + message;
	}
}
