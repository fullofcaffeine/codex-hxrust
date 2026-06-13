package codexhx.runtime.app.persistence;

import codexhx.protocol.ThreadId;

class PersistedThreadReadRequest {
	public final threadId:ThreadId;
	public final includeTurns:Bool;
	public final includeArchived:Bool;

	public function new(threadId:ThreadId, includeTurns:Bool, includeArchived:Bool) {
		this.threadId = threadId;
		this.includeTurns = includeTurns;
		this.includeArchived = includeArchived;
	}

	public function validate():PersistenceBoundaryOutcome {
		if (threadId == null) {
			return PersistenceBoundaryOutcome.failure("invalid_thread_id", "thread id must be a UUID");
		}
		return PersistenceBoundaryOutcome.success("read_request_valid", "", [], threadId.toString());
	}
}
