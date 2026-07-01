package codexhx.runtime.tui.appserver;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;

/**
	Typed app-server notifications consumed by the minimal live TUI shell.
**/
enum TuiAppServerEvent {
	SessionStarted(sessionId:SessionId, threadId:ThreadId, modelLabel:String);
	ThreadStatus(threadId:ThreadId, status:TuiAppServerThreadStatus);
	AssistantDelta(threadId:ThreadId, delta:String);
	AssistantTurnDelta(threadId:ThreadId, turnId:TurnId, delta:String);
	TurnCompleted(threadId:ThreadId, turnId:TurnId);
	AgentThreadUpsert(threadId:ThreadId, agentNickname:String, agentRole:String, isClosed:Bool);
	AgentThreadActivity(threadId:ThreadId, agentPath:String, isRunning:Bool);
	AgentThreadClosed(threadId:ThreadId);
	AgentThreadRemoved(threadId:ThreadId);
	ActiveThreadChanged(threadId:ThreadId);
	Disconnected(message:String);
}
