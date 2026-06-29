package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

/**
	Effects emitted while app-server notifications update the TUI shell.
**/
enum TuiAppServerShellEffect {
	RequestRegistered(requestId:RequestId, method:TuiAppServerRequestMethod);
	StaleResponseRejected(requestId:RequestId, method:TuiAppServerRequestMethod);
	SessionAttached(sessionId:SessionId, threadId:ThreadId);
	PromptSubmitSent(envelope:TuiPromptSubmitEnvelope);
	AppServerEventApplied(event:TuiAppServerEvent);
	AppServerEventIgnored(event:TuiAppServerEvent);
	AgentNavigationUpdated(threadId:ThreadId);
	ActiveThreadChanged(threadId:ThreadId);
	Disconnected(message:String);
	DrawRequested;
}
