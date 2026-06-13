package codexhx.runtime.app.threadread;

class ThreadReadTurnSummary {
	public final id:String;
	public final status:ThreadReadTurnStatus;
	public final items:Array<ThreadReadTurnItemSummary>;

	public function new(id:String, status:ThreadReadTurnStatus, items:Array<ThreadReadTurnItemSummary>) {
		this.id = id;
		this.status = status;
		this.items = items;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (item in items) {
			parts.push(item.summary());
		}
		return "turn=" + id + ";status=" + status + ";items=" + Std.string(items.length) + "[" + parts.join("|") + "]";
	}
}
