package codexhx.runtime.app.threadread;

class ThreadReadTurnProjectionOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final turns:Array<ThreadReadTurnSummary>;

	function new(ok:Bool, code:String, message:String, turns:Array<ThreadReadTurnSummary>) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.turns = turns;
	}

	public static function success(turns:Array<ThreadReadTurnSummary>):ThreadReadTurnProjectionOutcome {
		return new ThreadReadTurnProjectionOutcome(true, "turns_projected", "", turns);
	}

	public static function failure(code:String, message:String):ThreadReadTurnProjectionOutcome {
		return new ThreadReadTurnProjectionOutcome(false, code, message, []);
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (turn in turns) {
			parts.push(turn.summary());
		}
		return "projection:"
			+ code
			+ ";ok="
			+ (ok ? "true" : "false")
			+ ";turns="
			+ Std.string(turns.length)
			+ ";["
			+ parts.join("||")
			+ "]";
	}
}
