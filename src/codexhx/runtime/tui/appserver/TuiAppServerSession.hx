package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.runtime.tui.agent.AgentNavigationDirection;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import haxe.json.Value;

/**
	Runtime-neutral ownership contract for the TUI app-server session.

	The interface follows upstream `tui/app_server_session.rs`: it owns startup,
	thread attachment, turn requests, inbound events, server-request responses,
	and shutdown. It is synchronous for the current tracer, so callers do not
	depend on Tokio or another target runtime. A later async driver can schedule
	these operations without changing the TUI-facing contract.
**/
interface TuiAppServerSession {
	function shell():ChatWidgetShellState;
	function activeSession():Null<SessionId>;
	function activeThread():Null<ThreadId>;
	function primaryThread():Null<ThreadId>;
	function activeTurn():Null<TurnId>;
	function activeTurnIdText():String;
	function lastStartedTurnIdText():String;
	function lastCompletedTurnIdText():String;
	function lastInterruptedTurnIdText():String;
	function completedTurnCount():Int;
	function interruptedTurnCount():Int;
	function lastInterruptCode():String;
	function hasPendingSubmittedTurn():Bool;
	function canDrainSubmittedTurnLateJsonl():Bool;

	function bootstrap(requestId:RequestId, sessionId:SessionId, primaryThreadId:ThreadId, modelLabel:String):Array<TuiAppServerShellEffect>;
	function startTurn(requestId:RequestId, promptText:String):TuiPromptSubmitResult;
	function interruptTurn(requestId:RequestId):TuiPromptTurnInterruptResult;
	function drainSubmittedTurnLateJsonl(maxLinesPerBatch:Int, maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult;
	function deliverSubmittedTurnJsonlBatchLines(lines:Array<String>):TuiPromptSubmittedTurnJsonlBatchResult;

	function enqueueEvent(event:TuiAppServerEvent):Void;
	function hasPendingEvent():Bool;
	function nextEvent():Null<TuiAppServerEvent>;
	function receiveEvent(event:TuiAppServerEvent):Array<TuiAppServerShellEffect>;
	function activateAdjacentAgent(direction:AgentNavigationDirection):Array<TuiAppServerShellEffect>;

	/** Passes a typed JSON result through the app-server response boundary. */
	function resolveServerRequest(requestId:RequestId, result:Value):TuiAppServerRequestResponseOutcome;

	/** Passes a typed JSON-RPC error through the app-server response boundary. */
	function rejectServerRequest(requestId:RequestId, error:Value):TuiAppServerRequestResponseOutcome;

	function shutdown(code:String):TuiPromptTransportShutdownReport;
}
