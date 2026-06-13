package codexhx.runtime.app.threadread;

class ThreadReadResumeIdleContinuationOutcome {
	public final ok:Bool;
	public final code:String;
	public final operation:ThreadReadTokenUsageReplayDeliveryOperation;
	public final idleHookEmitted:Bool;
	public final goalContinuationRequested:Bool;
	public final turnStarted:Bool;
	public final activeGoalCleared:Bool;
	public final skipped:Bool;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		idleHookEmitted:Bool,
		goalContinuationRequested:Bool,
		turnStarted:Bool,
		activeGoalCleared:Bool,
		skipped:Bool,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.operation = operation;
		this.idleHookEmitted = idleHookEmitted;
		this.goalContinuationRequested = goalContinuationRequested;
		this.turnStarted = turnStarted;
		this.activeGoalCleared = activeGoalCleared;
		this.skipped = skipped;
		this.sequence = sequence;
		this.message = message;
	}

	public static function makeStarted(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		sequence:String
	):ThreadReadResumeIdleContinuationOutcome {
		return new ThreadReadResumeIdleContinuationOutcome(
			true,
			"continuation_started",
			operation,
			true,
			true,
			true,
			false,
			false,
			sequence,
			"active goal continuation requested and host accepted automatic idle turn start"
		);
	}

	public static function makeRejected(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		sequence:String
	):ThreadReadResumeIdleContinuationOutcome {
		return new ThreadReadResumeIdleContinuationOutcome(
			true,
			"continuation_rejected_by_host",
			operation,
			true,
			true,
			false,
			false,
			true,
			sequence,
			"active goal continuation requested but host rejected automatic idle work"
		);
	}

	public static function makeIdleOnly(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		code:String,
		sequence:String,
		activeGoalCleared:Bool,
		message:String
	):ThreadReadResumeIdleContinuationOutcome {
		return new ThreadReadResumeIdleContinuationOutcome(
			true,
			code,
			operation,
			true,
			false,
			false,
			activeGoalCleared,
			true,
			sequence,
			message
		);
	}

	public static function makeSkipped(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		code:String,
		sequence:String,
		message:String
	):ThreadReadResumeIdleContinuationOutcome {
		return new ThreadReadResumeIdleContinuationOutcome(
			true,
			code,
			operation,
			false,
			false,
			false,
			false,
			true,
			sequence,
			message
		);
	}

	public static function failure(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		code:String,
		message:String
	):ThreadReadResumeIdleContinuationOutcome {
		return new ThreadReadResumeIdleContinuationOutcome(
			false,
			code,
			operation,
			false,
			false,
			false,
			false,
			false,
			"none",
			message
		);
	}

	public function summary():String {
		return "operation=" + operation
			+ ";ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";idleHookEmitted=" + (idleHookEmitted ? "true" : "false")
			+ ";goalContinuationRequested=" + (goalContinuationRequested ? "true" : "false")
			+ ";turnStarted=" + (turnStarted ? "true" : "false")
			+ ";activeGoalCleared=" + (activeGoalCleared ? "true" : "false")
			+ ";skipped=" + (skipped ? "true" : "false")
			+ ";sequence=" + sequence
			+ ";message=" + message;
	}
}
