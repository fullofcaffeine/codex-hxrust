package codexhx.runtime.app.persistence;

import codexhx.protocol.PathLikeId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

class ThreadPersistenceMetadata {
	public final threadId:ThreadId;
	public final sessionId:SessionId;
	public final rolloutPath:PathLikeId;
	public final historyItemCount:Int;
	public final persistedItemCount:Int;
	public final rolloutItemKinds:Array<String>;
	public final includeHistory:Bool;
	public final archived:Bool;
	public final goalStateRequested:Bool;

	public function new(threadId:ThreadId, sessionId:SessionId, rolloutPath:PathLikeId, historyItemCount:Int, persistedItemCount:Int,
			rolloutItemKinds:Array<String>, includeHistory:Bool, archived:Bool, goalStateRequested:Bool) {
		this.threadId = threadId;
		this.sessionId = sessionId;
		this.rolloutPath = rolloutPath;
		this.historyItemCount = historyItemCount;
		this.persistedItemCount = persistedItemCount;
		this.rolloutItemKinds = rolloutItemKinds;
		this.includeHistory = includeHistory;
		this.archived = archived;
		this.goalStateRequested = goalStateRequested;
	}

	public function validate():PersistenceBoundaryOutcome {
		if (threadId == null)
			return PersistenceBoundaryOutcome.failure("invalid_thread_id", "thread id must be a UUID");
		if (sessionId == null)
			return PersistenceBoundaryOutcome.failure("invalid_session_id", "session id must be a UUID");
		if (rolloutPath == null)
			return PersistenceBoundaryOutcome.failure("invalid_rollout_path", "rollout path must be a non-empty scalar");
		if (!isAbsolutePath(rolloutPath.toString())) {
			return PersistenceBoundaryOutcome.failure("relative_rollout_path", "rollout path must be absolute");
		}
		if (historyItemCount < 0)
			return PersistenceBoundaryOutcome.failure("invalid_history_count", "history item count must be non-negative");
		if (persistedItemCount < 0)
			return PersistenceBoundaryOutcome.failure("invalid_persisted_count", "persisted item count must be non-negative");
		if (persistedItemCount > historyItemCount) {
			return PersistenceBoundaryOutcome.failure("persisted_count_exceeds_history", "persisted item count cannot exceed history item count");
		}
		if (rolloutItemKinds.length != historyItemCount) {
			return PersistenceBoundaryOutcome.failure("rollout_item_count_mismatch", "rollout item kinds must match history item count");
		}
		for (kind in rolloutItemKinds) {
			if (kind == null || kind.length == 0) {
				return PersistenceBoundaryOutcome.failure("invalid_rollout_item_kind", "rollout item kinds must be non-empty");
			}
		}
		return PersistenceBoundaryOutcome.success("metadata_valid", "", [], summary());
	}

	public function summary():String {
		return "thread=" + threadId.toString() + ";session=" + sessionId.toString() + ";rollout=" + rolloutPath.toString() + ";history="
			+ Std.string(historyItemCount) + ";persisted=" + Std.string(persistedItemCount) + ";kinds=" + rolloutItemKinds.join("|") + ";includeHistory="
			+ boolText(includeHistory) + ";archived=" + boolText(archived) + ";goalState=" + boolText(goalStateRequested);
	}

	static function isAbsolutePath(path:String):Bool {
		if (path.length == 0)
			return false;
		if (path.charAt(0) == "/")
			return true;
		return path.length > 2 && path.charAt(1) == ":" && (path.charAt(2) == "/" || path.charAt(2) == "\\");
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
