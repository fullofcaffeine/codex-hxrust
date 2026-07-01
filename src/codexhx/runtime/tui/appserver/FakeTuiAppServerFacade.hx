package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellEffect;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.chatwidget.ChatWidgetStatusKind;
import codexhx.runtime.tui.chatwidget.ChatWidgetTranscriptRole;
import codexhx.runtime.tui.agent.AgentNavigationDirection;
import codexhx.runtime.tui.agent.AgentNavigationState;
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
	final agentNavigationValue:AgentNavigationState;
	final promptTransport:TuiPromptTransport;
	// StringMap forces string keys; only this facade converts RequestId at the map boundary.
	final pending:StringMap<TuiAppServerPendingRequest>;
	final queue:Array<TuiAppServerEvent>;
	var activeSessionValue:Null<SessionId>;
	var primaryThreadValue:Null<ThreadId>;
	var activeThreadValue:Null<ThreadId>;
	var activeTurnValue:Null<TurnId>;
	var lastStartedTurnValue:Null<TurnId>;
	var lastCompletedTurnValue:Null<TurnId>;
	var lastInterruptedTurnValue:Null<TurnId>;
	var completedTurnCountValue:Int;
	var interruptedTurnCountValue:Int;
	var lastInterruptCodeValue:String;
	var latestAttachGeneration:Int;
	var latestPromptGeneration:Int;
	var lastPromptLifecycleValue:TuiPromptPendingRequestLifecycle;

	public function new(shell:ChatWidgetShellState, ?promptTransport:TuiPromptTransport) {
		this.shellValue = shell == null ? ChatWidgetShellState.initial("model pending") : shell;
		this.agentNavigationValue = new AgentNavigationState();
		this.promptTransport = promptTransport == null ? new JsonRpcTuiPromptTransport() : promptTransport;
		this.pending = new StringMap<TuiAppServerPendingRequest>();
		this.queue = [];
		this.activeSessionValue = null;
		this.primaryThreadValue = null;
		this.activeThreadValue = null;
		this.activeTurnValue = null;
		this.lastStartedTurnValue = null;
		this.lastCompletedTurnValue = null;
		this.lastInterruptedTurnValue = null;
		this.completedTurnCountValue = 0;
		this.interruptedTurnCountValue = 0;
		this.lastInterruptCodeValue = "";
		this.latestAttachGeneration = 0;
		this.latestPromptGeneration = 0;
		this.lastPromptLifecycleValue = TuiPromptPendingRequestLifecycle.none();
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

	public function primaryThread():Null<ThreadId> {
		return primaryThreadValue;
	}

	public function activeTurn():Null<TurnId> {
		return activeTurnValue;
	}

	public function activeTurnIdText():String {
		return turnText(activeTurnValue);
	}

	public function hasPendingSubmittedTurn():Bool {
		return activeTurnValue != null;
	}

	public function lastStartedTurnIdText():String {
		return turnText(lastStartedTurnValue);
	}

	public function lastCompletedTurnIdText():String {
		return turnText(lastCompletedTurnValue);
	}

	public function lastInterruptedTurnIdText():String {
		return turnText(lastInterruptedTurnValue);
	}

	public function completedTurnCount():Int {
		return completedTurnCountValue;
	}

	public function interruptedTurnCount():Int {
		return interruptedTurnCountValue;
	}

	public function lastInterruptCode():String {
		return lastInterruptCodeValue;
	}

	public function agentNavigation():AgentNavigationState {
		return agentNavigationValue;
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

	public function submitPrompt(requestId:RequestId, promptText:String):TuiPromptSubmitResult {
		final text = normalized(promptText, "");
		if (text.length == 0)
			return TuiPromptSubmitResult.refused(TuiPromptSubmitStatus.EmptyPrompt);
		if (activeSessionValue == null)
			return TuiPromptSubmitResult.refused(TuiPromptSubmitStatus.MissingSession);
		if (activeThreadValue == null)
			return TuiPromptSubmitResult.refused(TuiPromptSubmitStatus.MissingThread);

		final envelope = new TuiPromptSubmitEnvelope(requestId, activeSessionValue, activeThreadValue, text);
		latestPromptGeneration = latestPromptGeneration + 1;
		final pendingBeforeRegister = pendingCount();
		final pendingRequest = new TuiAppServerPendingRequest(requestId, TuiAppServerRequestMethod.PromptSubmit, activeSessionValue, activeThreadValue,
			"prompt submit", latestPromptGeneration);
		pending.set(requestId.toString(), pendingRequest);
		lastPromptLifecycleValue = TuiPromptPendingRequestLifecycle.registered(requestId, pendingBeforeRegister, pendingCount());
		final effects:Array<TuiAppServerShellEffect> = [
			TuiAppServerShellEffect.RequestRegistered(requestId, TuiAppServerRequestMethod.PromptSubmit),
			TuiAppServerShellEffect.PromptSubmitSent(envelope)
		];
		final transportOutcome = promptTransport.submitPrompt(envelope);
		if (transportOutcome == null || !transportOutcome.isAccepted()) {
			resolvePromptPending(requestId, false);
			return TuiPromptSubmitResult.transportRejected(envelope, effects);
		}
		recordTurnStarted(transportOutcome.response());
		resolvePromptPending(requestId, true);
		for (event in transportOutcome.events())
			enqueue(event);
		return TuiPromptSubmitResult.accepted(envelope, effects);
	}

	public function interruptActiveTurn(requestId:RequestId):TuiPromptTurnInterruptResult {
		if (activeSessionValue == null) {
			lastInterruptCodeValue = "missing_session";
			return TuiPromptTurnInterruptResult.rejected(lastInterruptCodeValue);
		}
		if (activeThreadValue == null) {
			lastInterruptCodeValue = "missing_thread";
			return TuiPromptTurnInterruptResult.rejected(lastInterruptCodeValue);
		}
		if (activeTurnValue == null) {
			lastInterruptCodeValue = "no_active_turn";
			return TuiPromptTurnInterruptResult.rejected(lastInterruptCodeValue);
		}
		final envelope = new TuiPromptTurnInterruptEnvelope(requestId, activeSessionValue, activeThreadValue, activeTurnValue);
		final effects:Array<TuiAppServerShellEffect> = [
			TuiAppServerShellEffect.RequestRegistered(requestId, TuiAppServerRequestMethod.TurnInterrupt),
			TuiAppServerShellEffect.TurnInterruptSent(envelope)
		];
		final outcome = promptTransport.interruptTurn(envelope);
		if (outcome == null || !outcome.isAccepted()) {
			lastInterruptCodeValue = outcome == null ? "missing_interrupt_outcome" : outcome.code();
			return TuiPromptTurnInterruptResult.transportRejected(envelope, effects, lastInterruptCodeValue);
		}
		recordTurnInterrupted();
		lastInterruptCodeValue = outcome.code();
		for (event in outcome.events())
			enqueue(event);
		return TuiPromptTurnInterruptResult.accepted(envelope, effects);
	}

	public function deliverSubmittedTurnCompletion(threadId:ThreadId, turnId:TurnId):TuiPromptSubmittedTurnCompletionResult {
		final status = submittedTurnCompletionStatus(threadId, turnId);
		if (status != TuiPromptSubmittedTurnCompletionStatus.Accepted)
			return TuiPromptSubmittedTurnCompletionResult.rejected(status, threadId, turnId);
		enqueue(TuiAppServerEvent.TurnCompleted(threadId, turnId));
		enqueue(TuiAppServerEvent.ThreadStatus(threadId, TuiAppServerThreadStatus.Ready("ready")));
		return TuiPromptSubmittedTurnCompletionResult.accepted(threadId, turnId, 2);
	}

	public function deliverSubmittedTurnAssistantDelta(threadId:ThreadId, turnId:TurnId, delta:String):TuiPromptSubmittedTurnStreamDeliveryResult {
		final text = normalized(delta, "");
		final status = submittedTurnStreamDeliveryStatus(threadId, turnId, text);
		if (status != TuiPromptSubmittedTurnStreamDeliveryStatus.Accepted)
			return TuiPromptSubmittedTurnStreamDeliveryResult.rejected(status, threadId, turnId, text);
		enqueue(TuiAppServerEvent.AssistantTurnDelta(threadId, turnId, text));
		return TuiPromptSubmittedTurnStreamDeliveryResult.accepted(threadId, turnId, text, 1);
	}

	public function deliverSubmittedTurnJsonlStreamLines(lines:Array<String>):TuiPromptSubmittedTurnJsonlDeliveryResult {
		final lineCount = lines == null ? 0 : lines.length;
		final decoded = new TuiPromptJsonRpcInboundLineDecoder().decodeStreamNotifications(lines);
		if (!decoded.isAccepted())
			return TuiPromptSubmittedTurnJsonlDeliveryResult.rejected(TuiPromptSubmittedTurnJsonlDeliveryStatus.DecodeRejected, decoded.code(), lineCount, 0);
		final notifications = decoded.streamNotifications();
		if (notifications.length != 1) {
			return TuiPromptSubmittedTurnJsonlDeliveryResult.rejected(TuiPromptSubmittedTurnJsonlDeliveryStatus.MultipleNotifications,
				notifications.length == 0 ? "missing_stream_notification" : "multiple_stream_notifications", lineCount, notifications.length);
		}
		final events = TuiPromptJsonRpcNotificationProjector.projectWithStreamNotifications(notifications, []);
		if (events.length != 1)
			return TuiPromptSubmittedTurnJsonlDeliveryResult.rejected(TuiPromptSubmittedTurnJsonlDeliveryStatus.UnsupportedNotification,
				"unsupported_stream_notification", lineCount, notifications.length);
		return deliverSubmittedTurnProjectedEvent(events[0], lineCount, notifications.length);
	}

	public function deliverSubmittedTurnJsonlCompletionLines(lines:Array<String>):TuiPromptSubmittedTurnJsonlCompletionResult {
		final lineCount = lines == null ? 0 : lines.length;
		final decoded = new TuiPromptJsonRpcInboundLineDecoder().decodeStreamNotifications(lines);
		if (!decoded.isAccepted())
			return TuiPromptSubmittedTurnJsonlCompletionResult.rejected(TuiPromptSubmittedTurnJsonlCompletionStatus.DecodeRejected, decoded.code(), lineCount,
				0);
		final notifications = decoded.streamNotifications();
		if (notifications.length != 1) {
			return TuiPromptSubmittedTurnJsonlCompletionResult.rejected(TuiPromptSubmittedTurnJsonlCompletionStatus.MultipleNotifications,
				notifications.length == 0 ? "missing_stream_notification" : "multiple_stream_notifications", lineCount, notifications.length);
		}
		final events = TuiPromptJsonRpcNotificationProjector.projectTurnCompletionNotifications(notifications);
		if (events.length != 1)
			return TuiPromptSubmittedTurnJsonlCompletionResult.rejected(TuiPromptSubmittedTurnJsonlCompletionStatus.UnsupportedNotification,
				"unsupported_stream_notification", lineCount, notifications.length);
		return deliverSubmittedTurnProjectedCompletionEvent(events[0], lineCount, notifications.length);
	}

	public function shutdownPromptTransport(code:String):TuiPromptTransportShutdownReport {
		return promptTransport.shutdown(code);
	}

	public function receive(event:TuiAppServerEvent):Array<TuiAppServerShellEffect> {
		final effects:Array<TuiAppServerShellEffect> = [];
		switch event {
			case TuiAppServerEvent.SessionStarted(sessionId, threadId, modelLabel):
				activeSessionValue = sessionId;
				primaryThreadValue = threadId;
				activeThreadValue = threadId;
				clearTurnState();
				agentNavigationValue.clear();
				agentNavigationValue.upsert(threadId, "", "", false);
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				appendShellEffects(effects, shellValue.setModelLabel(modelLabel));
				appendShellEffects(effects, shellValue.setStatus(ChatWidgetStatusKind.Idle, "session started"));
				refreshAgentLabel(effects);
				appendShellEffects(effects,
					shellValue.appendTranscript(ChatWidgetTranscriptRole.System,
						"session " + sessionId.toString() + " attached to thread " + threadId.toString()));
			case TuiAppServerEvent.ThreadStatus(threadId, status):
				if (!activeThreadMatches(threadId)) {
					effects.push(TuiAppServerShellEffect.AppServerEventIgnored(event));
				} else {
					effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
					appendShellEffects(effects, shellValue.setStatus(statusKind(status), statusText(status)));
					recordThreadStatusForTurn(status);
				}
			case TuiAppServerEvent.AssistantDelta(threadId, delta):
				if (!activeThreadMatches(threadId)) {
					effects.push(TuiAppServerShellEffect.AppServerEventIgnored(event));
				} else {
					effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
					appendShellEffects(effects, shellValue.appendTranscript(ChatWidgetTranscriptRole.Assistant, delta));
				}
			case TuiAppServerEvent.AssistantTurnDelta(threadId, turnId, delta):
				if (!activeThreadMatches(threadId) || !activeTurnMatches(turnId)) {
					effects.push(TuiAppServerShellEffect.AppServerEventIgnored(event));
				} else {
					effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
					appendShellEffects(effects, shellValue.appendTranscript(ChatWidgetTranscriptRole.Assistant, delta));
				}
			case TuiAppServerEvent.TurnCompleted(threadId, turnId):
				if (!activeThreadMatches(threadId) || !activeTurnMatches(turnId)) {
					effects.push(TuiAppServerShellEffect.AppServerEventIgnored(event));
				} else {
					effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
					recordTurnCompleted(turnId);
				}
			case TuiAppServerEvent.AgentThreadUpsert(threadId, agentNickname, agentRole, isClosed):
				agentNavigationValue.upsert(threadId, agentNickname, agentRole, isClosed);
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				effects.push(TuiAppServerShellEffect.AgentNavigationUpdated(threadId));
				refreshAgentLabel(effects);
			case TuiAppServerEvent.AgentThreadActivity(threadId, agentPath, isRunning):
				agentNavigationValue.recordActivity(threadId, agentPath, isRunning);
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				effects.push(TuiAppServerShellEffect.AgentNavigationUpdated(threadId));
				refreshAgentLabel(effects);
			case TuiAppServerEvent.AgentThreadClosed(threadId):
				agentNavigationValue.markClosed(threadId);
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				effects.push(TuiAppServerShellEffect.AgentNavigationUpdated(threadId));
				refreshAgentLabel(effects);
			case TuiAppServerEvent.AgentThreadRemoved(threadId):
				agentNavigationValue.remove(threadId);
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				effects.push(TuiAppServerShellEffect.AgentNavigationUpdated(threadId));
				if (activeThreadMatches(threadId) && primaryThreadValue != null) {
					activeThreadValue = primaryThreadValue;
					effects.push(TuiAppServerShellEffect.ActiveThreadChanged(primaryThreadValue));
				}
				refreshAgentLabel(effects);
			case TuiAppServerEvent.ActiveThreadChanged(threadId):
				activeThreadValue = threadId;
				effects.push(TuiAppServerShellEffect.AppServerEventApplied(event));
				effects.push(TuiAppServerShellEffect.ActiveThreadChanged(threadId));
				refreshAgentLabel(effects);
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

	public function activateAdjacentAgent(direction:AgentNavigationDirection):Array<TuiAppServerShellEffect> {
		final effects:Array<TuiAppServerShellEffect> = [];
		final nextThread = agentNavigationValue.adjacentThreadId(activeThreadValue, direction);
		if (nextThread == null)
			return effects;
		activeThreadValue = nextThread;
		effects.push(TuiAppServerShellEffect.ActiveThreadChanged(nextThread));
		refreshAgentLabel(effects);
		return effects;
	}

	public function pendingCount():Int {
		var count = 0;
		for (_ in pending)
			count = count + 1;
		return count;
	}

	public function lastPromptLifecycle():TuiPromptPendingRequestLifecycle {
		return lastPromptLifecycleValue;
	}

	function resolvePromptPending(requestId:RequestId, accepted:Bool):Void {
		final pendingBefore = pendingCount();
		pending.remove(requestId.toString());
		final pendingAfter = pendingCount();
		lastPromptLifecycleValue = accepted ? TuiPromptPendingRequestLifecycle.resolved(requestId, pendingBefore,
			pendingAfter) : TuiPromptPendingRequestLifecycle.rejected(requestId, pendingBefore, pendingAfter);
	}

	function recordTurnStarted(response:TuiPromptTurnStartResponse):Void {
		if (response == null)
			return;
		activeTurnValue = response.turnId;
		lastStartedTurnValue = response.turnId;
	}

	function recordThreadStatusForTurn(status:TuiAppServerThreadStatus):Void {
		switch status {
			case Ready(_):
				recordActiveTurnCompleted();
			case Failed(_):
				recordActiveTurnCompleted();
			case Working(_):
		}
	}

	function recordActiveTurnCompleted():Void {
		if (activeTurnValue == null)
			return;
		recordTurnCompleted(activeTurnValue);
	}

	function recordTurnCompleted(turnId:TurnId):Void {
		lastCompletedTurnValue = turnId;
		if (activeTurnMatches(turnId))
			activeTurnValue = null;
		completedTurnCountValue = completedTurnCountValue + 1;
	}

	function recordTurnInterrupted():Void {
		if (activeTurnValue == null)
			return;
		lastInterruptedTurnValue = activeTurnValue;
		activeTurnValue = null;
		interruptedTurnCountValue = interruptedTurnCountValue + 1;
	}

	function clearTurnState():Void {
		activeTurnValue = null;
		lastStartedTurnValue = null;
		lastCompletedTurnValue = null;
		lastInterruptedTurnValue = null;
		completedTurnCountValue = 0;
		interruptedTurnCountValue = 0;
		lastInterruptCodeValue = "";
	}

	function activeThreadMatches(threadId:ThreadId):Bool {
		return activeThreadValue != null && activeThreadValue.equals(threadId);
	}

	function activeTurnMatches(turnId:TurnId):Bool {
		final activeTurn = activeTurnValue;
		return activeTurn != null && activeTurn.equals(turnId);
	}

	function submittedTurnCompletionStatus(threadId:ThreadId, turnId:TurnId):TuiPromptSubmittedTurnCompletionStatus {
		if (!activeThreadMatches(threadId))
			return TuiPromptSubmittedTurnCompletionStatus.WrongThread;
		if (activeTurnValue == null) {
			final lastCompletedTurn = lastCompletedTurnValue;
			if (lastCompletedTurn != null && lastCompletedTurn.equals(turnId))
				return TuiPromptSubmittedTurnCompletionStatus.DuplicateCompletion;
			final lastInterruptedTurn = lastInterruptedTurnValue;
			if (lastInterruptedTurn != null && lastInterruptedTurn.equals(turnId))
				return TuiPromptSubmittedTurnCompletionStatus.StaleInterruptedTurn;
			return TuiPromptSubmittedTurnCompletionStatus.NoSubmittedTurn;
		}
		if (!activeTurnMatches(turnId))
			return TuiPromptSubmittedTurnCompletionStatus.WrongTurn;
		return TuiPromptSubmittedTurnCompletionStatus.Accepted;
	}

	function submittedTurnStreamDeliveryStatus(threadId:ThreadId, turnId:TurnId, delta:String):TuiPromptSubmittedTurnStreamDeliveryStatus {
		if (delta.length == 0)
			return TuiPromptSubmittedTurnStreamDeliveryStatus.EmptyDelta;
		if (!activeThreadMatches(threadId))
			return TuiPromptSubmittedTurnStreamDeliveryStatus.WrongThread;
		if (activeTurnValue == null) {
			final lastCompletedTurn = lastCompletedTurnValue;
			if (lastCompletedTurn != null && lastCompletedTurn.equals(turnId))
				return TuiPromptSubmittedTurnStreamDeliveryStatus.DuplicateCompletedTurn;
			final lastInterruptedTurn = lastInterruptedTurnValue;
			if (lastInterruptedTurn != null && lastInterruptedTurn.equals(turnId))
				return TuiPromptSubmittedTurnStreamDeliveryStatus.StaleInterruptedTurn;
			return TuiPromptSubmittedTurnStreamDeliveryStatus.NoSubmittedTurn;
		}
		if (!activeTurnMatches(turnId))
			return TuiPromptSubmittedTurnStreamDeliveryStatus.WrongTurn;
		return TuiPromptSubmittedTurnStreamDeliveryStatus.Accepted;
	}

	function deliverSubmittedTurnProjectedEvent(event:TuiAppServerEvent, lineCount:Int, notificationCount:Int):TuiPromptSubmittedTurnJsonlDeliveryResult {
		return switch event {
			case TuiAppServerEvent.AssistantTurnDelta(threadId, turnId, delta):
				final delivered = deliverSubmittedTurnAssistantDelta(threadId, turnId, delta);
				if (delivered.acceptedDelivery()) TuiPromptSubmittedTurnJsonlDeliveryResult.accepted(delivered, lineCount,
					notificationCount); else
					TuiPromptSubmittedTurnJsonlDeliveryResult.rejectedWithDelivery(TuiPromptSubmittedTurnJsonlDeliveryStatus.StreamDeliveryRejected,
						delivered.statusText(), delivered, lineCount, notificationCount);
			case _:
				TuiPromptSubmittedTurnJsonlDeliveryResult.rejected(TuiPromptSubmittedTurnJsonlDeliveryStatus.UnsupportedNotification,
					"unsupported_projected_event", lineCount, notificationCount);
		}
	}

	function deliverSubmittedTurnProjectedCompletionEvent(event:TuiAppServerEvent, lineCount:Int,
			notificationCount:Int):TuiPromptSubmittedTurnJsonlCompletionResult {
		return switch event {
			case TuiAppServerEvent.TurnCompleted(threadId, turnId):
				final delivered = deliverSubmittedTurnCompletion(threadId, turnId);
				if (delivered.acceptedCompletion()) TuiPromptSubmittedTurnJsonlCompletionResult.accepted(delivered, lineCount,
					notificationCount); else
					TuiPromptSubmittedTurnJsonlCompletionResult.rejectedWithCompletion(TuiPromptSubmittedTurnJsonlCompletionStatus.CompletionDeliveryRejected,
						delivered.statusText(), delivered, lineCount,
					notificationCount);
			case _:
				TuiPromptSubmittedTurnJsonlCompletionResult.rejected(TuiPromptSubmittedTurnJsonlCompletionStatus.UnsupportedNotification,
					"unsupported_projected_event", lineCount, notificationCount);
		}
	}

	function refreshAgentLabel(effects:Array<TuiAppServerShellEffect>):Void {
		appendShellEffects(effects, shellValue.setActiveAgentLabel(agentNavigationValue.activeAgentLabel(activeThreadValue, primaryThreadValue)));
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

	static function turnText(turnId:Null<TurnId>):String {
		return turnId == null ? "" : turnId.toString();
	}
}
