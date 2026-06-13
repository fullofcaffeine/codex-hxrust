package codexhx.runtime.app.threadread;

class ThreadReadTurnsPage {
	public final data:Array<ThreadReadTurnSummary>;
	public final nextCursor:String;
	public final backwardsCursor:String;

	public function new(data:Array<ThreadReadTurnSummary>, nextCursor:String, backwardsCursor:String) {
		this.data = data;
		this.nextCursor = nextCursor;
		this.backwardsCursor = backwardsCursor;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (turn in data) {
			parts.push(turn.summary());
		}
		return "page:data=" + Std.string(data.length)
			+ ";next=" + (nextCursor.length == 0 ? "null" : nextCursor)
			+ ";back=" + (backwardsCursor.length == 0 ? "null" : backwardsCursor)
			+ ";turns=[" + parts.join("||") + "]";
	}
}
