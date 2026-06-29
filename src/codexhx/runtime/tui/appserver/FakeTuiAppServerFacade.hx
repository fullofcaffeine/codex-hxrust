package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellEffect;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.chatwidget.ChatWidgetStatusKind;
import codexhx.runtime.tui.chatwidget.ChatWidgetTranscriptRole;
import haxe.ds.StringMap;

/**
	Credential-free app-server facade for the first production-shaped live shell.

	The facade models request IDs, stale attach responses, session ownership, and
	thread-scoped notifications without sockets, JSON parsing, model calls, or DB
	handles. Later transports can preserve this typed surface while replacing the
	in-process event queue.
**/
class FakeTuiAppServerFacade {
	final shellValue:ChatWidgetShellState;
	// StringMap forces string keys; only this facade converts RequestId at the map boundary.
	final pending:StringMap<TuiAppServerPendingRequest>;
	final queue:Array<TuiAppServerEvent>;
	var activeSessionValue:Null<SessionId>;
	var activeThreadValue:Null<ThreadId>;
	var latestAttachGeneration:Int;

	public function new(shell:ChatWidgetShellState) {
		this.shellValue = shell == null ? ChatWidgetShellState.initial("model pending") : shell;
		this.pending = new StringMap<TuiAppServerPendingRequest>();
		this.queue = [];
		this.activeSessionValue = null;
		this.activeThreadValue = null;
		this.latestAttachGeneration = 0;
	}

	public function shell():ChatWidgetShellState {
		return shellValue;
	}

	public function activeSession():Null<SessionId> {
		return activeSessionValue;
	}

	public function activeThread():Null<ThreadId> {
		return activeThreadValue;
	}

	public function startSessionAttach(requestId:RequestId, sessionId:SessionId, threadId:ThreadId, modelLabel:String):Array<TuiAppServerShellEffect> {
		latestAttachGeneration = latestAttachGeneration + 1;
		final request = new TuiAppServerPendingRequest(requestId, TuiAppServerRequestMethod.AttachSession, sessionId, threadId, modelLabel,
			latestAttachGeneration);
		pending.set(requestId.toString(), request);
		return [
			TuiAppServerShellEffect.RequestRegistered(requestId, TuiAppServerRequestMethod.AttachSession)
		];
	}

	public function completeSessionAttach(requestId:RequestId):Array<TuiAppServerShellEffect> {
		final key = requestId.toString();
		final request = pending.get(key);
		if (request == null)
			return [
				TuiAppServerShellEffect.StaleResponseRejected(requestId, TuiAppServerRequestMethod.AttachSession)
			];
		pending.remove(key);
		if (request.generation != latestAttachGeneration)
			return [TuiAppServerShellEffect.StaleResponseRejected(requestId, request.method)];

		activeSessionValue = request.sessionId;
		activeThreadValue = request.threadId;
		final effects:Array<TuiAppServerShellEffect> = [TuiAppServerShellEffect.SessionAttached(request.sessionId, request.threadId)];
		appendEffects(effects, receive(TuiAppServerEvent.SessionStarted(request.sessionId, request.threadId, request.modelLabel)));
		return effects;
	}

	public function receive(event:TuiAppServerEvent):Array<TuiAppServerShellEffect> {
		final effects:Array<TuiAppServerShellEffect> = [];
		switch event {
			case TuiAppServerEvent.SessionStarted(sessionId, threadId, modelLabel):
				activeSessionValue = sessionId;
				activeThreadValue = threadId;
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				appendShellEffects(effects, shellValue.setModelLabel(modelLabel));
				appendShellEffects(effects, shellValue.setStatus(ChatWidgetStatusKind.Idle, "session started"));
				appendShellEffects(effects,
					shellValue.appendTranscript(ChatWidgetTranscriptRole.System,
						"session " + sessionId.toString() + " attached to thread " + threadId.toString()));
			case TuiAppServerEvent.ThreadStatus(threadId, status):
				if (!activeThreadMatches(threadId)) {
					effects.push(TuiAppServerShellEffect.AppServerEventIgnored(event));
				} else {
					effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
					appendShellEffects(effects, shellValue.setStatus(statusKind(status), statusText(status)));
				}
			case TuiAppServerEvent.AssistantDelta(threadId, delta):
				if (!activeThreadMatches(threadId)) {
					effects.push(TuiAppServerShellEffect.AppServerEventIgnored(event));
				} else {
					effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
					appendShellEffects(effects, shellValue.appendTranscript(ChatWidgetTranscriptRole.Assistant, delta));
				}
			case TuiAppServerEvent.Disconnected(message):
				final text = normalized(message, "app-server disconnected");
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				effects.push(TuiAppServerShellEffect.Disconnected(text));
				appendShellEffects(effects, shellValue.setStatus(ChatWidgetStatusKind.Error, text));
				appendShellEffects(effects, shellValue.appendTranscript(ChatWidgetTranscriptRole.System, text));
		}
		return effects;
	}

	public function enqueue(event:TuiAppServerEvent):Void {
		queue.push(event);
	}

	public function queuedCount():Int {
		return queue.length;
	}

	public function shiftQueued():Null<TuiAppServerEvent> {
		if (queue.length == 0)
			return null;
		return queue.shift();
	}

	public function drainQueued():Array<TuiAppServerShellEffect> {
		final effects:Array<TuiAppServerShellEffect> = [];
		while (queue.length > 0) {
			final event = shiftQueued();
			if (event != null)
				appendEffects(effects, receive(event));
		}
		return effects;
	}

	public function pendingCount():Int {
		var count = 0;
		for (_ in pending)
			count = count + 1;
		return count;
	}

	function activeThreadMatches(threadId:ThreadId):Bool {
		return activeThreadValue != null && activeThreadValue.equals(threadId);
	}

	static function appendEffects(target:Array<TuiAppServerShellEffect>, source:Array<TuiAppServerShellEffect>):Void {
		for (effect in source)
			target.push(effect);
	}

	static function appendShellEffects(target:Array<TuiAppServerShellEffect>, source:Array<ChatWidgetShellEffect>):Void {
		for (effect in source) {
			switch effect {
				case ChatWidgetShellEffect.DrawRequested:
					target.push(TuiAppServerShellEffect.DrawRequested);
				case ChatWidgetShellEffect.PromptSubmitted(_):
				case ChatWidgetShellEffect.ExitRequested(_):
			}
		}
	}

	static function statusKind(status:TuiAppServerThreadStatus):ChatWidgetStatusKind {
		return switch status {
			case Ready(_):
				ChatWidgetStatusKind.Idle;
			case Working(_):
				ChatWidgetStatusKind.Working;
			case Failed(_):
				ChatWidgetStatusKind.Error;
		}
	}

	static function statusText(status:TuiAppServerThreadStatus):String {
		return switch status {
			case Ready(text):
				normalized(text, "ready");
			case Working(text):
				normalized(text, "working");
			case Failed(text):
				normalized(text, "failed");
		}
	}

	static function normalized(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
