package codexhx.native.state;

import codexhx.protocol.ThreadId;
import codexhx.runtime.app.persistence.PersistenceBoundaryOutcome;

class StateSqliteQueryRequest {
	public final threadId:ThreadId;
	public final archivedOnly:Null<Bool>;

	public function new(threadId:ThreadId, archivedOnly:Null<Bool>) {
		this.threadId = threadId;
		this.archivedOnly = archivedOnly;
	}

	public function validate():PersistenceBoundaryOutcome {
		if (threadId == null) {
			return PersistenceBoundaryOutcome.failure("invalid_thread_id", "thread id must be a UUID");
		}
		return PersistenceBoundaryOutcome.success("query_valid", "", [], threadId.toString());
	}
}
