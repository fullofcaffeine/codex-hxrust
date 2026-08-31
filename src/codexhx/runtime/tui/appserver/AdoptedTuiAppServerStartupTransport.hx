package codexhx.runtime.tui.appserver;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

/** Compatibility transport for callers that already own session and thread IDs. */
class AdoptedTuiAppServerStartupTransport implements TuiAppServerStartupTransport {
	final sessionId:SessionId;
	final threadId:ThreadId;

	public function new(sessionId:SessionId, threadId:ThreadId) {
		this.sessionId = sessionId;
		this.threadId = threadId;
	}

	public function open(request:TuiAppServerStartupRequest):TuiAppServerStartupOutcome {
		if (request == null)
			return TuiAppServerStartupOutcome.rejected("missing_startup_request");
		return TuiAppServerStartupOutcome.accepted(sessionId, threadId, request.modelLabel, []);
	}
}
