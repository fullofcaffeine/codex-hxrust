package codexhx.runtime.model.streamitem;

class ModelTurnLifecycleOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final turnId:String;
	public final terminalKind:ModelTurnLifecycleTerminalKind;
	public final projectedEventKind:ModelTurnLifecycleEventKind;
	public final terminalStopHookRequestId:String;
	public final samplingErrorTerminalRequestId:String;
	public final rolloutFlushedBeforeTerminal:Bool;
	public final rolloutWarningEmitted:Bool;
	public final turnStopLifecycleEmitted:Bool;
	public final turnAbortLifecycleEmitted:Bool;
	public final turnErrorLifecycleAlreadyEmitted:Bool;
	public final turnCompleteEmitted:Bool;
	public final turnAbortedEmitted:Bool;
	public final completionSuppressedForCancellation:Bool;
	public final completedAfterError:Bool;
	public final interruptedMarkerRecorded:Bool;
	public final lastAgentMessageCarried:Bool;
	public final lastAgentMessage:String;
	public final activeTurnCleared:Bool;
	public final threadIdleLifecycleEmitted:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, turnId:String, terminalKind:ModelTurnLifecycleTerminalKind,
			projectedEventKind:ModelTurnLifecycleEventKind, terminalStopHookRequestId:String, samplingErrorTerminalRequestId:String,
			rolloutFlushedBeforeTerminal:Bool, rolloutWarningEmitted:Bool, turnStopLifecycleEmitted:Bool, turnAbortLifecycleEmitted:Bool,
			turnErrorLifecycleAlreadyEmitted:Bool, turnCompleteEmitted:Bool, turnAbortedEmitted:Bool, completionSuppressedForCancellation:Bool,
			completedAfterError:Bool, interruptedMarkerRecorded:Bool, lastAgentMessageCarried:Bool, lastAgentMessage:String, activeTurnCleared:Bool,
			threadIdleLifecycleEmitted:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.turnId = turnId == null ? "" : turnId;
		this.terminalKind = terminalKind == null ? ModelTurnLifecycleTerminalKind.Completed : terminalKind;
		this.projectedEventKind = projectedEventKind == null ? ModelTurnLifecycleEventKind.TurnComplete : projectedEventKind;
		this.terminalStopHookRequestId = terminalStopHookRequestId == null ? "" : terminalStopHookRequestId;
		this.samplingErrorTerminalRequestId = samplingErrorTerminalRequestId == null ? "" : samplingErrorTerminalRequestId;
		this.rolloutFlushedBeforeTerminal = rolloutFlushedBeforeTerminal;
		this.rolloutWarningEmitted = rolloutWarningEmitted;
		this.turnStopLifecycleEmitted = turnStopLifecycleEmitted;
		this.turnAbortLifecycleEmitted = turnAbortLifecycleEmitted;
		this.turnErrorLifecycleAlreadyEmitted = turnErrorLifecycleAlreadyEmitted;
		this.turnCompleteEmitted = turnCompleteEmitted;
		this.turnAbortedEmitted = turnAbortedEmitted;
		this.completionSuppressedForCancellation = completionSuppressedForCancellation;
		this.completedAfterError = completedAfterError;
		this.interruptedMarkerRecorded = interruptedMarkerRecorded;
		this.lastAgentMessageCarried = lastAgentMessageCarried;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.activeTurnCleared = activeTurnCleared;
		this.threadIdleLifecycleEmitted = threadIdleLifecycleEmitted;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";turn=" + turnId + ";terminalKind=" + terminalKind
			+ ";projectedEventKind=" + projectedEventKind + ";terminalStopHookRequest=" + noneIfEmpty(terminalStopHookRequestId)
			+ ";samplingErrorTerminalRequest=" + noneIfEmpty(samplingErrorTerminalRequestId) + ";rolloutFlushedBeforeTerminal="
			+ boolText(rolloutFlushedBeforeTerminal) + ";rolloutWarningEmitted=" + boolText(rolloutWarningEmitted) + ";turnStopLifecycleEmitted="
			+ boolText(turnStopLifecycleEmitted) + ";turnAbortLifecycleEmitted=" + boolText(turnAbortLifecycleEmitted) + ";turnErrorLifecycleAlreadyEmitted="
			+ boolText(turnErrorLifecycleAlreadyEmitted) + ";turnCompleteEmitted=" + boolText(turnCompleteEmitted) + ";turnAbortedEmitted="
			+ boolText(turnAbortedEmitted) + ";completionSuppressedForCancellation=" + boolText(completionSuppressedForCancellation)
			+ ";completedAfterError=" + boolText(completedAfterError) + ";interruptedMarkerRecorded=" + boolText(interruptedMarkerRecorded)
			+ ";lastAgentMessageCarried=" + boolText(lastAgentMessageCarried) + ";lastAgentMessage=" + noneIfEmpty(lastAgentMessage) + ";activeTurnCleared="
			+ boolText(activeTurnCleared) + ";threadIdleLifecycleEmitted=" + boolText(threadIdleLifecycleEmitted) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
