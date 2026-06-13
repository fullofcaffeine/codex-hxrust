package codexhx.runtime.app.threadread;

import codexhx.protocol.ThreadId;

class ThreadReadTurnsPageRequest {
	public final threadId:ThreadId;
	public final cursor:String;
	public final limit:Int;
	public final sortDirection:ThreadReadTurnSortDirection;
	public final itemsView:ThreadReadTurnItemsView;

	public function new(
		threadId:ThreadId,
		cursor:String,
		limit:Int,
		sortDirection:ThreadReadTurnSortDirection,
		itemsView:ThreadReadTurnItemsView
	) {
		this.threadId = threadId;
		this.cursor = cursor;
		this.limit = limit;
		this.sortDirection = sortDirection;
		this.itemsView = itemsView;
	}
}
