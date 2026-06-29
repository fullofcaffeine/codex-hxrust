package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

/**
	Typed request envelope emitted when the minimal live composer submits text.
**/
class TuiPromptSubmitEnvelope {
	public final requestId:RequestId;
	public final sessionId:SessionId;
	public final threadId:ThreadId;
	public final promptText:String;

	public function new(requestId:RequestId, sessionId:SessionId, threadId:ThreadId, promptText:String) {
		this.requestId = requestId;
		this.sessionId = sessionId;
		this.threadId = threadId;
		this.promptText = promptText == null ? "" : promptText;
	}
}
