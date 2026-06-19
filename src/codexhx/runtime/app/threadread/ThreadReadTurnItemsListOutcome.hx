package codexhx.runtime.app.threadread;

class ThreadReadTurnItemsListOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final threadId:String;
	public final turnId:String;

	function new(ok:Bool, code:String, message:String, threadId:String, turnId:String) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.threadId = threadId;
		this.turnId = turnId;
	}

	public static function unsupported(threadId:String, turnId:String):ThreadReadTurnItemsListOutcome {
		return new ThreadReadTurnItemsListOutcome(false, "method_not_found", "thread/turns/items/list is not supported yet", threadId, turnId);
	}

	public static function failure(code:String, message:String):ThreadReadTurnItemsListOutcome {
		return new ThreadReadTurnItemsListOutcome(false, code, message, "", "");
	}

	public function summary():String {
		return "turn-items:" + code + ";ok=" + (ok ? "true" : "false") + ";thread=" + (threadId.length == 0 ? "null" : threadId) + ";turn="
			+ (turnId.length == 0 ? "null" : turnId) + ";message=" + message;
	}
}
