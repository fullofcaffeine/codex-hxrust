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

    #if reflaxe_rust_profile
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

    static function createSchema(cnx:Connection):Void {
        cnx.request("CREATE TABLE codex_threads ("
            + "thread_id TEXT PRIMARY KEY,"
            + "session_id TEXT NOT NULL,"
            + "rollout_path TEXT NOT NULL,"
            + "history_item_count INTEGER NOT NULL,"
            + "persisted_item_count INTEGER NOT NULL,"
            + "archived INTEGER NOT NULL"
            + ")");
    }

    static function applySqliteRequest(cnx:Connection, request:StateSqliteReconcileRequest):StateSqliteReconcileOutcome {
        final validated = request.metadata.validate();
        if (!validated.ok) {
            return StateSqliteReconcileOutcome.failure(validated.code, realBackend, validated.message, rowCount(cnx));
        }
        if (!request.mutationEnabled) {
            return StateSqliteReconcileOutcome.failure("native_mutation_disabled", realBackend, "native SQLite writes require explicit enablement", rowCount(cnx));
        }

        final threadId = request.metadata.threadId.toString();
        final sessionId = request.metadata.sessionId.toString();
        final rolloutPath = request.metadata.rolloutPath.toString();
        final archived = request.metadata.archived ? 1 : 0;

        cnx.request("INSERT INTO codex_threads (thread_id, session_id, rollout_path, history_item_count, persisted_item_count, archived) VALUES ("
            + cnx.quote(threadId) + ","
            + cnx.quote(sessionId) + ","
            + cnx.quote(rolloutPath) + ","
            + Std.string(request.metadata.historyItemCount) + ","
            + Std.string(request.metadata.persistedItemCount) + ","
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
        if (!result.hasNext()) return 0;
        result.next();
        return result.getIntResult(0);
    }

    static function readRow(cnx:Connection, threadId:String):NativeStateRow {
        final result = cnx.request("SELECT thread_id, session_id, rollout_path, history_item_count, persisted_item_count, archived "
            + "FROM codex_threads WHERE thread_id = " + cnx.quote(threadId));
        if (!result.hasNext()) throw "missing reconciled SQLite row";
        result.next();
        return new NativeStateRow(
            result.getResult(0),
            result.getResult(1),
            result.getResult(2),
            result.getIntResult(3),
            result.getIntResult(4),
            result.getIntResult(5) == 1
        );
    }
    #end

    #if !reflaxe_rust_profile
    static function reconcileWithFixtureSimulation(requests:Array<StateSqliteReconcileRequest>):Array<StateSqliteReconcileOutcome> {
        final rows:Array<NativeStateRow> = [];
        final outcomes:Array<StateSqliteReconcileOutcome> = [];
        for (request in requests) {
            outcomes.push(applyFixtureRequest(rows, request));
        }
        return outcomes;
    }

    static function applyFixtureRequest(rows:Array<NativeStateRow>, request:StateSqliteReconcileRequest):StateSqliteReconcileOutcome {
        final validated = request.metadata.validate();
        if (!validated.ok) {
            return StateSqliteReconcileOutcome.failure(validated.code, fixtureBackend, validated.message, rows.length);
        }
        if (!request.mutationEnabled) {
            return StateSqliteReconcileOutcome.failure("native_mutation_disabled", fixtureBackend, "native SQLite writes require explicit enablement", rows.length);
        }

        final row = new NativeStateRow(
            request.metadata.threadId.toString(),
            request.metadata.sessionId.toString(),
            request.metadata.rolloutPath.toString(),
            request.metadata.historyItemCount,
            request.metadata.persistedItemCount,
            request.metadata.archived
        );
        final existing = findRow(rows, row.threadId);
        if (existing < 0) {
            rows.push(row);
        } else {
            rows[existing] = row;
        }
        return StateSqliteReconcileOutcome.success(fixtureBackend, rows.length, row);
    }

    static function findRow(rows:Array<NativeStateRow>, threadId:String):Int {
        var i = 0;
        while (i < rows.length) {
            if (rows[i].threadId == threadId) return i;
            i = i + 1;
        }
        return -1;
    }
    #end
}
