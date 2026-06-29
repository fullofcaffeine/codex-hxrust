package codexhx.runtime.tui.appserver;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

/**
	Typed app-server notifications consumed by the minimal live TUI shell.
**/
enum TuiAppServerEvent {
	SessionStarted(sessionId:SessionId, threadId:ThreadId, modelLabel:String);
	ThreadStatus(threadId:ThreadId, status:TuiAppServerThreadStatus);
	AssistantDelta(threadId:ThreadId, delta:String);
	Disconnected(message:String);
}
