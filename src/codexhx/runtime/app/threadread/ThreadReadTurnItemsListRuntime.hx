package codexhx.runtime.app.threadread;

class ThreadReadTurnItemsListRuntime {
	static final DEFAULT_LIMIT:Int = 50;
	static final MAX_LIMIT:Int = 100;

	public static function runCases(requests:Array<ThreadReadTurnItemsListRequest>):ThreadReadTurnItemsListReport {
		final outcomes:Array<ThreadReadTurnItemsListOutcome> = [];
		for (request in requests) {
			outcomes.push(run(request));
		}
		return new ThreadReadTurnItemsListReport(outcomes);
	}

	public static function run(request:ThreadReadTurnItemsListRequest):ThreadReadTurnItemsListOutcome {
		if (request.threadId == null) return ThreadReadTurnItemsListOutcome.failure("invalid_thread_id", "thread id must be a UUID");
		if (request.turnId == null) return ThreadReadTurnItemsListOutcome.failure("invalid_turn_id", "turn id must be non-empty");
		if (request.cursor.length > 0 && !isCursorShapeValid(request.cursor)) {
			return ThreadReadTurnItemsListOutcome.failure("invalid_cursor", "cursor must be an opaque JSON object string");
		}
		if (request.limit < -1) return ThreadReadTurnItemsListOutcome.failure("invalid_limit", "limit must be omitted, null, or an unsigned integer");
		if (request.limit > MAX_LIMIT) return ThreadReadTurnItemsListOutcome.failure("invalid_limit", "limit exceeds selected runtime guard");
		if (!ThreadReadTurnSortDirection.isValid(request.sortDirection)) {
			return ThreadReadTurnItemsListOutcome.failure("invalid_sort_direction", "sortDirection must be asc or desc");
		}
		final _pageSize = request.limit < 0 ? DEFAULT_LIMIT : request.limit;
		return ThreadReadTurnItemsListOutcome.unsupported(request.threadId.toString(), request.turnId.toString());
	}

	static function isCursorShapeValid(cursor:String):Bool {
		final parsed = try {
			codexhx.protocol.json.CodexJson.parse(cursor);
		} catch (_:Dynamic) {
			return false;
		}
		if (!parsed.ok) return false;
		return switch parsed.value {
			case JObject(_, _): true;
			case _: false;
		}
	}
}
