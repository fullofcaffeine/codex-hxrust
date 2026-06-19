package codexhx.native.state;

class NativeStateRow {
	public final threadId:String;
	public final sessionId:String;
	public final rolloutPath:String;
	public final historyItemCount:Int;
	public final persistedItemCount:Int;
	public final archived:Bool;

	public function new(threadId:String, sessionId:String, rolloutPath:String, historyItemCount:Int, persistedItemCount:Int, archived:Bool) {
		this.threadId = threadId;
		this.sessionId = sessionId;
		this.rolloutPath = rolloutPath;
		this.historyItemCount = historyItemCount;
		this.persistedItemCount = persistedItemCount;
		this.archived = archived;
	}

	public function summary():String {
		return "thread=" + threadId + ";session=" + sessionId + ";rollout=" + rolloutPath + ";history=" + Std.string(historyItemCount) + ";persisted="
			+ Std.string(persistedItemCount) + ";archived=" + (archived ? "true" : "false");
	}
}
