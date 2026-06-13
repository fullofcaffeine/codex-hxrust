package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageOwnerOutcome {
	public final ok:Bool;
	public final code:String;
	public final turnId:String;
	public final turnIndex:Int;
	public final reason:ThreadReadTokenUsageOwnerReason;
	public final message:String;

	function new(ok:Bool, code:String, turnId:String, turnIndex:Int, reason:ThreadReadTokenUsageOwnerReason, message:String) {
		this.ok = ok;
		this.code = code;
		this.turnId = turnId;
		this.turnIndex = turnIndex;
		this.reason = reason;
		this.message = message;
	}

	public static function selected(turnId:String, turnIndex:Int, reason:ThreadReadTokenUsageOwnerReason):ThreadReadTokenUsageOwnerOutcome {
		return new ThreadReadTokenUsageOwnerOutcome(true, "selected", turnId, turnIndex, reason, "token usage owner selected");
	}

	public static function failure(code:String, reason:ThreadReadTokenUsageOwnerReason, message:String):ThreadReadTokenUsageOwnerOutcome {
		return new ThreadReadTokenUsageOwnerOutcome(false, code, "", -1, reason, message);
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false")
			+ ";code=" + code
			+ ";turnId=" + turnId
			+ ";turnIndex=" + Std.string(turnIndex)
			+ ";reason=" + reason
			+ ";message=" + message;
	}
}
