package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageOwnerRequest {
	public final turns:Array<ThreadReadTurnSummary>;
	public final ownerHint:Null<ThreadReadTokenUsageTurnOwnerHint>;

	public function new(turns:Array<ThreadReadTurnSummary>, ownerHint:Null<ThreadReadTokenUsageTurnOwnerHint>) {
		this.turns = turns;
		this.ownerHint = ownerHint;
	}

	public function summary():String {
		return "turns=" + Std.string(turns.length)
			+ ";ownerHint=" + (ownerHint == null ? "none" : ownerHint.summary());
	}
}
