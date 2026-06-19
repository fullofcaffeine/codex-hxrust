package codexhx.runtime.app.threadread;

class ThreadReadTurnsPager {
	static final DEFAULT_LIMIT:Int = 25;
	static final MAX_LIMIT:Int = 100;

	public static function pageCases(turns:Array<ThreadReadTurnSummary>, requests:Array<ThreadReadTurnsPageRequest>):ThreadReadTurnsPageReport {
		final outcomes:Array<ThreadReadTurnsPageOutcome> = [];
		for (request in requests) {
			outcomes.push(page(turns, request));
		}
		return new ThreadReadTurnsPageReport(outcomes);
	}

	public static function page(turns:Array<ThreadReadTurnSummary>, request:ThreadReadTurnsPageRequest):ThreadReadTurnsPageOutcome {
		if (request.threadId == null)
			return ThreadReadTurnsPageOutcome.failure("invalid_thread_id", "thread id must be a UUID");
		if (!ThreadReadTurnSortDirection.isValid(request.sortDirection)) {
			return ThreadReadTurnsPageOutcome.failure("invalid_sort_direction", "sortDirection must be asc or desc");
		}
		if (!ThreadReadTurnItemsView.isValid(request.itemsView)) {
			return ThreadReadTurnsPageOutcome.failure("invalid_turn_items_view", "itemsView must be notLoaded, summary, or full");
		}
		if (turns.length == 0)
			return ThreadReadTurnsPageOutcome.success(new ThreadReadTurnsPage([], "", ""));

		final cursor = request.cursor.length == 0 ? null : ThreadReadTurnsCursor.parse(request.cursor);
		if (cursor != null && !cursor.ok)
			return ThreadReadTurnsPageOutcome.failure(cursor.code, cursor.message);

		final anchor = cursor == null ? null : cursor.cursor;
		final anchorIndex = anchor == null ? -1 : findTurnIndex(turns, anchor.turnId.toString());
		if (anchor != null && anchorIndex < 0) {
			return ThreadReadTurnsPageOutcome.failure("invalid_cursor_anchor", "invalid cursor: anchor turn is no longer present");
		}

		final pageSize = clampLimit(request.limit);
		final keyed:Array<TurnIndex> = [];
		if (request.sortDirection == ThreadReadTurnSortDirection.Asc) {
			var i = 0;
			while (i < turns.length) {
				if (anchor == null || (anchor.includeAnchor ? i >= anchorIndex : i > anchorIndex)) {
					keyed.push(new TurnIndex(i, turns[i]));
				}
				i = i + 1;
			}
		} else {
			var i = turns.length - 1;
			while (i >= 0) {
				if (anchor == null || (anchor.includeAnchor ? i <= anchorIndex : i < anchorIndex)) {
					keyed.push(new TurnIndex(i, turns[i]));
				}
				i = i - 1;
			}
		}

		final more = keyed.length > pageSize;
		while (keyed.length > pageSize)
			keyed.pop();

		final pageTurns:Array<ThreadReadTurnSummary> = [];
		for (entry in keyed) {
			pageTurns.push(applyItemsView(entry.turn, request.itemsView));
		}
		final backwardsCursor = keyed.length == 0 ? "" : ThreadReadTurnsCursor.encode(keyed[0].turn.id, true);
		final nextCursor = more && keyed.length > 0 ? ThreadReadTurnsCursor.encode(keyed[keyed.length - 1].turn.id, false) : "";
		return ThreadReadTurnsPageOutcome.success(new ThreadReadTurnsPage(pageTurns, nextCursor, backwardsCursor));
	}

	static function clampLimit(limit:Int):Int {
		final base = limit < 0 ? DEFAULT_LIMIT : limit;
		if (base < 1)
			return 1;
		if (base > MAX_LIMIT)
			return MAX_LIMIT;
		return base;
	}

	static function findTurnIndex(turns:Array<ThreadReadTurnSummary>, turnId:String):Int {
		var i = 0;
		while (i < turns.length) {
			if (turns[i].id == turnId)
				return i;
			i = i + 1;
		}
		return -1;
	}

	static function applyItemsView(turn:ThreadReadTurnSummary, itemsView:ThreadReadTurnItemsView):ThreadReadTurnSummary {
		if (itemsView == ThreadReadTurnItemsView.Full)
			return turn;
		if (itemsView == ThreadReadTurnItemsView.NotLoaded)
			return new ThreadReadTurnSummary(turn.id, turn.status, []);

		var firstUser:Null<ThreadReadTurnItemSummary> = null;
		var finalAgent:Null<ThreadReadTurnItemSummary> = null;
		for (item in turn.items) {
			if (firstUser == null && item.kind == ThreadReadTurnItemKind.UserMessage)
				firstUser = item;
			if (item.kind == ThreadReadTurnItemKind.AgentMessage)
				finalAgent = item;
		}
		final out:Array<ThreadReadTurnItemSummary> = [];
		if (firstUser != null)
			out.push(firstUser);
		if (finalAgent != null && finalAgent != firstUser)
			out.push(finalAgent);
		return new ThreadReadTurnSummary(turn.id, turn.status, out);
	}
}

class TurnIndex {
	public final index:Int;
	public final turn:ThreadReadTurnSummary;

	public function new(index:Int, turn:ThreadReadTurnSummary) {
		this.index = index;
		this.turn = turn;
	}
}
