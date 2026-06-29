package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

/**
	Typed pending request record used to reject stale app-server responses.
**/
class TuiAppServerPendingRequest {
	public final requestId:RequestId;
	public final method:TuiAppServerRequestMethod;
	public final sessionId:SessionId;
	public final threadId:ThreadId;
	public final modelLabel:String;
	public final generation:Int;

	public function new(requestId:RequestId, method:TuiAppServerRequestMethod, sessionId:SessionId, threadId:ThreadId, modelLabel:String, generation:Int) {
		this.requestId = requestId;
		this.method = method;
		this.sessionId = sessionId;
		this.threadId = threadId;
		this.modelLabel = modelLabel == null || modelLabel.length == 0 ? "model pending" : modelLabel;
		this.generation = generation;
	}
}
