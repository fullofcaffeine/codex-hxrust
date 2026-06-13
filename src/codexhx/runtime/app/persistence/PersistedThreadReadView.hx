package codexhx.runtime.app.persistence;

import codexhx.protocol.PathLikeId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

class PersistedThreadReadView {
	public final threadId:ThreadId;
	public final sessionId:SessionId;
	public final rolloutPath:PathLikeId;
	public final archived:Bool;
	public final status:String;
	public final history:PersistedThreadHistorySummary;

	public function new(
		threadId:ThreadId,
		sessionId:SessionId,
		rolloutPath:PathLikeId,
		archived:Bool,
		status:String,
		history:PersistedThreadHistorySummary
	) {
		this.threadId = threadId;
		this.sessionId = sessionId;
		this.rolloutPath = rolloutPath;
		this.archived = archived;
		this.status = status;
		this.history = history;
	}

	public function summary():String {
		return "thread=" + threadId.toString()
			+ ";session=" + sessionId.toString()
			+ ";path=" + rolloutPath.toString()
			+ ";status=" + status
			+ ";archived=" + (archived ? "true" : "false")
			+ ";" + history.summary();
	}
}
