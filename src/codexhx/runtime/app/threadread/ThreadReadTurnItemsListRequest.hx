package codexhx.runtime.app.threadread;

import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;

class ThreadReadTurnItemsListRequest {
	public final threadId:ThreadId;
	public final turnId:TurnId;
	public final cursor:String;
	public final limit:Int;
	public final sortDirection:ThreadReadTurnSortDirection;

	public function new(threadId:ThreadId, turnId:TurnId, cursor:String, limit:Int, sortDirection:ThreadReadTurnSortDirection) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.cursor = cursor;
		this.limit = limit;
		this.sortDirection = sortDirection;
	}
}
