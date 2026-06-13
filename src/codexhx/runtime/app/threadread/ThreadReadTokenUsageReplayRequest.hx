package codexhx.runtime.app.threadread;

import codexhx.protocol.ThreadId;

class ThreadReadTokenUsageReplayRequest {
	public final threadId:ThreadId;
	public final ownerOutcome:ThreadReadTokenUsageOwnerOutcome;
	public final tokenUsage:Null<ThreadReadTokenUsageInfo>;

	function new(threadId:ThreadId, ownerOutcome:ThreadReadTokenUsageOwnerOutcome, tokenUsage:Null<ThreadReadTokenUsageInfo>) {
		this.threadId = threadId;
		this.ownerOutcome = ownerOutcome;
		this.tokenUsage = tokenUsage;
	}

	public static function fromRaw(threadId:String, ownerOutcome:ThreadReadTokenUsageOwnerOutcome, tokenUsage:Null<ThreadReadTokenUsageInfo>):Null<ThreadReadTokenUsageReplayRequest> {
		final parsedThreadId = ThreadId.fromString(threadId);
		if (parsedThreadId == null) return null;
		return new ThreadReadTokenUsageReplayRequest(parsedThreadId, ownerOutcome, tokenUsage);
	}

	public function threadIdString():String {
		return threadId.toString();
	}
}
