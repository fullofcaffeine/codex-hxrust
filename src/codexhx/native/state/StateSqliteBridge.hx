package codexhx.native.state;

#if reflaxe_rust_profile
import sys.db.Connection;
import sys.db.Sqlite;
#end

class StateSqliteBridge {
	static inline final realBackend = "haxe_rust_sys_db_sqlite";
	static inline final fixtureBackend = "fixture_sqlite_simulation";

	public static function reconcileInMemory(requests:Array<StateSqliteReconcileRequest>):Array<StateSqliteReconcileOutcome> {
		#if reflaxe_rust_profile
		return reconcileWithSqlite(requests);
		#else
		return reconcileWithFixtureSimulation(requests);
		#end
	}

	public static function runInMemory(commands:Array<StateSqliteCommand>):StateSqliteAdapterReport {
		#if reflaxe_rust_profile
		return new StateSqliteAdapterReport(runCommandsWithSqlite(commands));
		#else
		return new StateSqliteAdapterReport(runCommandsWithFixtureSimulation(commands));
		#end
	}

	#if reflaxe_rust_profile
	static function runCommandsWithSqlite(commands:Array<StateSqliteCommand>):Array<StateSqliteOperationOutcome> {
		final outcomes:Array<StateSqliteOperationOutcome> = [];
		final cnx = Sqlite.open(":memory:");
		createSchema(cnx);
		for (command in commands) {
			outcomes.push(applySqliteCommand(cnx, command));
		}
		cnx.close();
		return outcomes;
	}

	static function reconcileWithSqlite(requests:Array<StateSqliteReconcileRequest>):Array<StateSqliteReconcileOutcome> {
		final outcomes:Array<StateSqliteReconcileOutcome> = [];
		final cnx = Sqlite.open(":memory:");
		createSchema(cnx);
		for (request in requests) {
			outcomes.push(applySqliteRequest(cnx, request));
		}
		cnx.close();
		return outcomes;
	}

	static function applySqliteCommand(cnx:Connection, command:StateSqliteCommand):StateSqliteOperationOutcome {
		return switch command {
			case Reconcile(request):
				StateSqliteOperationOutcome.fromReconcile(applySqliteRequest(cnx, request));
			case Query(request):
				applySqliteQuery(cnx, request);
		}
	}

	static function createSchema(cnx:Connection):Void {
		cnx.request("CREATE TABLE codex_threads (" + "thread_id TEXT PRIMARY KEY," + "session_id TEXT NOT NULL," + "rollout_path TEXT NOT NULL,"
			+ "history_item_count INTEGER NOT NULL," + "persisted_item_count INTEGER NOT NULL," + "archived INTEGER NOT NULL" + ")");
	}

	static function applySqliteRequest(cnx:Connection, request:StateSqliteReconcileRequest):StateSqliteReconcileOutcome {
		final validated = request.metadata.validate();
		if (!validated.ok) {
			return StateSqliteReconcileOutcome.failure(validated.code, realBackend, validated.message, rowCount(cnx));
		}
		if (!request.mutationEnabled) {
			return StateSqliteReconcileOutcome.failure("native_mutation_disabled", realBackend, "native SQLite writes require explicit enablement",
				rowCount(cnx));
		}

		final threadId = request.metadata.threadId.toString();
		final sessionId = request.metadata.sessionId.toString();
		final rolloutPath = request.metadata.rolloutPath.toString();
		final archived = request.metadata.archived ? 1 : 0;

		cnx.request("INSERT INTO codex_threads (thread_id, session_id, rollout_path, history_item_count, persisted_item_count, archived) VALUES ("
			+ cnx.quote(threadId)
			+ ","
			+ cnx.quote(sessionId)
			+ ","
			+ cnx.quote(rolloutPath)
			+ ","
			+ Std.string(request.metadata.historyItemCount)
			+ ","
			+ Std.string(request.metadata.persistedItemCount)
			+ ","
			+ Std.string(archived)
			+ ") ON CONFLICT(thread_id) DO UPDATE SET "
			+ "session_id=excluded.session_id,"
			+ "rollout_path=excluded.rollout_path,"
			+ "history_item_count=excluded.history_item_count,"
			+ "persisted_item_count=excluded.persisted_item_count,"
			+ "archived=excluded.archived");

		return StateSqliteReconcileOutcome.success(realBackend, rowCount(cnx), readRow(cnx, threadId));
	}

	static function rowCount(cnx:Connection):Int {
		final result = cnx.request("SELECT COUNT(*) AS row_count FROM codex_threads");
		if (!result.hasNext())
			return 0;
		result.next();
		return result.getIntResult(0);
	}

	static function readRow(cnx:Connection, threadId:String):NativeStateRow {
		final row = readOptionalRow(cnx, threadId);
		if (row == null)
			throw "missing reconciled SQLite row";
		return row;
	}

	static function applySqliteQuery(cnx:Connection, request:StateSqliteQueryRequest):StateSqliteOperationOutcome {
		final validated = request.validate();
		if (!validated.ok) {
			return StateSqliteOperationOutcome.failure("query", validated.code, realBackend, validated.message, rowCount(cnx));
		}

		final row = readOptionalRow(cnx, request.threadId.toString());
		if (row == null || !matchesArchivedOnly(row, request.archivedOnly)) {
			return StateSqliteOperationOutcome.failure("query", "thread_not_found", realBackend, "no SQLite metadata row matched thread id", rowCount(cnx));
		}
		return StateSqliteOperationOutcome.success("query", "query_found", realBackend, rowCount(cnx), row);
	}

	static function readOptionalRow(cnx:Connection, threadId:String):Null<NativeStateRow> {
		final result = cnx.request("SELECT thread_id, session_id, rollout_path, history_item_count, persisted_item_count, archived "
			+ "FROM codex_threads WHERE thread_id = "
			+ cnx.quote(threadId));
		if (!result.hasNext())
			return null;
		result.next();
		return new NativeStateRow(result.getResult(0), result.getResult(1), result.getResult(2), result.getIntResult(3), result.getIntResult(4),
			result.getIntResult(5) == 1);
	}
	#end

	#if !reflaxe_rust_profile
	static function runCommandsWithFixtureSimulation(commands:Array<StateSqliteCommand>):Array<StateSqliteOperationOutcome> {
		final rows:Array<NativeStateRow> = [];
		final outcomes:Array<StateSqliteOperationOutcome> = [];
		for (command in commands) {
			outcomes.push(applyFixtureCommand(rows, command));
		}
		return outcomes;
	}

	static function reconcileWithFixtureSimulation(requests:Array<StateSqliteReconcileRequest>):Array<StateSqliteReconcileOutcome> {
		final rows:Array<NativeStateRow> = [];
		final outcomes:Array<StateSqliteReconcileOutcome> = [];
		for (request in requests) {
			outcomes.push(applyFixtureRequest(rows, request));
		}
		return outcomes;
	}

	static function applyFixtureCommand(rows:Array<NativeStateRow>, command:StateSqliteCommand):StateSqliteOperationOutcome {
		return switch command {
			case Reconcile(request):
				StateSqliteOperationOutcome.fromReconcile(applyFixtureRequest(rows, request));
			case Query(request):
				applyFixtureQuery(rows, request);
		}
	}

	static function applyFixtureRequest(rows:Array<NativeStateRow>, request:StateSqliteReconcileRequest):StateSqliteReconcileOutcome {
		final validated = request.metadata.validate();
		if (!validated.ok) {
			return StateSqliteReconcileOutcome.failure(validated.code, fixtureBackend, validated.message, rows.length);
		}
		if (!request.mutationEnabled) {
			return StateSqliteReconcileOutcome.failure("native_mutation_disabled", fixtureBackend, "native SQLite writes require explicit enablement",
				rows.length);
		}

		final row = new NativeStateRow(request.metadata.threadId.toString(), request.metadata.sessionId.toString(), request.metadata.rolloutPath.toString(),
			request.metadata.historyItemCount, request.metadata.persistedItemCount, request.metadata.archived);
		final existing = findRow(rows, row.threadId);
		if (existing < 0) {
			rows.push(row);
		} else {
			rows[existing] = row;
		}
		return StateSqliteReconcileOutcome.success(fixtureBackend, rows.length, row);
	}

	static function applyFixtureQuery(rows:Array<NativeStateRow>, request:StateSqliteQueryRequest):StateSqliteOperationOutcome {
		final validated = request.validate();
		if (!validated.ok) {
			return StateSqliteOperationOutcome.failure("query", validated.code, fixtureBackend, validated.message, rows.length);
		}

		final index = findRow(rows, request.threadId.toString());
		if (index < 0 || !matchesArchivedOnly(rows[index], request.archivedOnly)) {
			return StateSqliteOperationOutcome.failure("query", "thread_not_found", fixtureBackend, "no SQLite metadata row matched thread id", rows.length);
		}
		return StateSqliteOperationOutcome.success("query", "query_found", fixtureBackend, rows.length, rows[index]);
	}

	static function findRow(rows:Array<NativeStateRow>, threadId:String):Int {
		var i = 0;
		while (i < rows.length) {
			if (rows[i].threadId == threadId)
				return i;
			i = i + 1;
		}
		return -1;
	}
	#end

	static function matchesArchivedOnly(row:NativeStateRow, archivedOnly:Null<Bool>):Bool {
		return archivedOnly == null || row.archived == archivedOnly;
	}
}
