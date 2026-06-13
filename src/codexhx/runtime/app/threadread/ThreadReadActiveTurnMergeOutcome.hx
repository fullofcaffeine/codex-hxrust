package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnMergeOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final threadStatus:ThreadReadThreadStatus;
	public final turns:Array<ThreadReadTurnSummary>;

	function new(ok:Bool, code:String, message:String, threadStatus:ThreadReadThreadStatus, turns:Array<ThreadReadTurnSummary>) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.threadStatus = threadStatus;
		this.turns = turns;
	}

	public static function success(threadStatus:ThreadReadThreadStatus, turns:Array<ThreadReadTurnSummary>):ThreadReadActiveTurnMergeOutcome {
		return new ThreadReadActiveTurnMergeOutcome(true, "turns_reconstructed", "", threadStatus, turns);
	}

	public static function failure(code:String, message:String):ThreadReadActiveTurnMergeOutcome {
		return new ThreadReadActiveTurnMergeOutcome(false, code, message, ThreadReadThreadStatus.NotLoaded, []);
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (turn in turns) {
			parts.push(turn.summary());
		}
		return "merge:" + code
			+ ";ok=" + (ok ? "true" : "false")
			+ ";threadStatus=" + threadStatus
			+ ";turns=" + Std.string(turns.length)
			+ ";[" + parts.join("||") + "]";
	}
}
