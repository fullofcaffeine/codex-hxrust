package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;

/**
	Shell-facing request facts for interrupting the active app-server turn.
**/
class TuiPromptTurnInterruptEnvelope {
	public final requestId:RequestId;
	public final sessionId:SessionId;
	public final threadId:ThreadId;
	public final turnId:TurnId;

	public function new(requestId:RequestId, sessionId:SessionId, threadId:ThreadId, turnId:TurnId) {
		this.requestId = requestId;
		this.sessionId = sessionId;
		this.threadId = threadId;
		this.turnId = turnId;
	}
}
