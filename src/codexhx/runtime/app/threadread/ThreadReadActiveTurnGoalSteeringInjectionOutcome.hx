package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnGoalSteeringInjectionOutcome {
	public final ok:Bool;
	public final code:String;
	public final injected:Bool;
	public final skipped:Bool;
	public final threadLookupAttempted:Bool;
	public final injectIfRunningAttempted:Bool;
	public final activeTurnRunning:Bool;
	public final pendingInputExtended:Bool;
	public final returnedItemUnchanged:Bool;
	public final injectedItemUnchanged:Bool;
	public final itemSummary:String;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		injected:Bool,
		skipped:Bool,
		threadLookupAttempted:Bool,
		injectIfRunningAttempted:Bool,
		activeTurnRunning:Bool,
		pendingInputExtended:Bool,
		returnedItemUnchanged:Bool,
		injectedItemUnchanged:Bool,
		itemSummary:String,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.injected = injected;
		this.skipped = skipped;
		this.threadLookupAttempted = threadLookupAttempted;
		this.injectIfRunningAttempted = injectIfRunningAttempted;
		this.activeTurnRunning = activeTurnRunning;
		this.pendingInputExtended = pendingInputExtended;
		this.returnedItemUnchanged = returnedItemUnchanged;
		this.injectedItemUnchanged = injectedItemUnchanged;
		this.itemSummary = itemSummary;
		this.sequence = sequence;
		this.message = message;
	}

	public static function makeInjected(itemSummary:String):ThreadReadActiveTurnGoalSteeringInjectionOutcome {
		return new ThreadReadActiveTurnGoalSteeringInjectionOutcome(
			true,
			"active_turn_steering_injected",
			true,
			false,
			true,
			true,
			true,
			true,
			false,
			true,
			itemSummary,
			"goal/steering/item->thread_manager/live_thread->inject_if_running->pending/input/extend",
			"goal steering item injected into the running turn"
		);
	}

	public static function makeSkipped(
		code:String,
		threadLookupAttempted:Bool,
		injectIfRunningAttempted:Bool,
		activeTurnRunning:Bool,
		returnedItemUnchanged:Bool,
		itemSummary:String,
		sequence:String,
		message:String
	):ThreadReadActiveTurnGoalSteeringInjectionOutcome {
		return new ThreadReadActiveTurnGoalSteeringInjectionOutcome(
			true,
			code,
			false,
			true,
			threadLookupAttempted,
			injectIfRunningAttempted,
			activeTurnRunning,
			false,
			returnedItemUnchanged,
			false,
			itemSummary,
			sequence,
			message
		);
	}

	public static function failure(code:String, itemSummary:String, message:String):ThreadReadActiveTurnGoalSteeringInjectionOutcome {
		return new ThreadReadActiveTurnGoalSteeringInjectionOutcome(
			false,
			code,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			itemSummary,
			"goal/objective_updated/item->failure",
			message
		);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";injected=" + (injected ? "true" : "false")
			+ ";skipped=" + (skipped ? "true" : "false")
			+ ";threadLookupAttempted=" + (threadLookupAttempted ? "true" : "false")
			+ ";injectIfRunningAttempted=" + (injectIfRunningAttempted ? "true" : "false")
			+ ";activeTurnRunning=" + (activeTurnRunning ? "true" : "false")
			+ ";pendingInputExtended=" + (pendingInputExtended ? "true" : "false")
			+ ";returnedItemUnchanged=" + (returnedItemUnchanged ? "true" : "false")
			+ ";injectedItemUnchanged=" + (injectedItemUnchanged ? "true" : "false")
			+ ";itemSummary=" + itemSummary
			+ ";sequence=" + sequence
			+ ";message=" + message;
	}
}
