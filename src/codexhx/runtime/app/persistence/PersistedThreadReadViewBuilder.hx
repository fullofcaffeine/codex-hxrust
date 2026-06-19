package codexhx.runtime.app.persistence;

import codexhx.native.state.NativeStateRow;
import codexhx.native.state.StateSqliteAdapterReport;
import codexhx.protocol.PathLikeId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

class PersistedThreadReadViewBuilder {
	public static function fromAdapterReport(adapterReport:StateSqliteAdapterReport, requests:Array<PersistedThreadReadRequest>):PersistedThreadReadReport {
		final outcomes:Array<PersistedThreadReadOutcome> = [];
		for (request in requests) {
			outcomes.push(readOne(adapterReport, request));
		}
		return new PersistedThreadReadReport(outcomes);
	}

	static function readOne(adapterReport:StateSqliteAdapterReport, request:PersistedThreadReadRequest):PersistedThreadReadOutcome {
		final validated = request.validate();
		if (!validated.ok) {
			return PersistedThreadReadOutcome.failure(validated.code, validated.message);
		}

		final row = findLatestRow(adapterReport, request.threadId.toString());
		if (row == null) {
			return PersistedThreadReadOutcome.failure("thread_not_found", "thread not loaded: " + request.threadId.toString());
		}
		if (row.archived && !request.includeArchived) {
			return PersistedThreadReadOutcome.failure("archived_thread_filtered", "archived thread requires includeArchived");
		}
		return viewFromRow(row, request.includeTurns);
	}

	static function findLatestRow(adapterReport:StateSqliteAdapterReport, threadId:String):Null<NativeStateRow> {
		var i = adapterReport.outcomes.length - 1;
		while (i >= 0) {
			final outcome = adapterReport.outcomes[i];
			if (outcome.ok && outcome.row != null && outcome.row.threadId == threadId) {
				return outcome.row;
			}
			i = i - 1;
		}
		return null;
	}

	static function viewFromRow(row:NativeStateRow, includeTurns:Bool):PersistedThreadReadOutcome {
		final threadId = ThreadId.fromString(row.threadId);
		if (threadId == null) {
			return PersistedThreadReadOutcome.failure("invalid_persisted_thread_id", "persisted row thread id must be a UUID");
		}
		final sessionId = SessionId.fromString(row.sessionId);
		if (sessionId == null) {
			return PersistedThreadReadOutcome.failure("invalid_persisted_session_id", "persisted row session id must be a UUID");
		}
		final rolloutPath = PathLikeId.fromString(row.rolloutPath);
		if (rolloutPath == null) {
			return PersistedThreadReadOutcome.failure("invalid_persisted_rollout_path", "persisted row rollout path must be non-empty");
		}
		if (row.historyItemCount < 0 || row.persistedItemCount < 0 || row.persistedItemCount > row.historyItemCount) {
			return PersistedThreadReadOutcome.failure("invalid_history_summary", "persisted history counts are inconsistent");
		}

		return PersistedThreadReadOutcome.success(new PersistedThreadReadView(threadId, sessionId, rolloutPath, row.archived, "notLoaded",
			new PersistedThreadHistorySummary(includeTurns, row.historyItemCount, row.persistedItemCount)));
	}
}
