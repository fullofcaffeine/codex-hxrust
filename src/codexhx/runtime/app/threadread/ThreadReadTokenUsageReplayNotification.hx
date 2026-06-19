package codexhx.runtime.app.threadread;

import codexhx.protocol.JsonScalar;

class ThreadReadTokenUsageReplayNotification {
	public final threadId:String;
	public final turnId:String;
	public final tokenUsage:ThreadReadTokenUsageInfo;

	public function new(threadId:String, turnId:String, tokenUsage:ThreadReadTokenUsageInfo) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.tokenUsage = tokenUsage;
	}

	public function method():String {
		return "thread/tokenUsage/updated";
	}

	public function summary():String {
		return "method=" + method() + ";threadId=" + threadId + ";turnId=" + turnId + ";" + tokenUsage.summary();
	}

	public function toJson():String {
		return "{\"method\":" + JsonScalar.quote(method()) + ",\"params\":{\"threadId\":" + JsonScalar.quote(threadId) + ",\"turnId\":"
			+ JsonScalar.quote(turnId) + ",\"tokenUsage\":" + tokenUsage.toJson() + "}}";
	}
}
