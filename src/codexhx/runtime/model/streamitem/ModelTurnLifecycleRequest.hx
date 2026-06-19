package codexhx.runtime.model.streamitem;

class ModelTurnLifecycleRequest {
	public final requestId:String;
	public final turnId:String;
	public final terminalKind:ModelTurnLifecycleTerminalKind;
	public final terminalStopHookOutcome:ModelTerminalStopHookOutcome;
	public final samplingErrorTerminalOutcome:ModelSamplingErrorTerminalOutcome;
	public final lastAgentMessage:String;
	public final abortReason:String;
	public final taskCancellationRequested:Bool;
	public final rolloutFlushOk:Bool;
	public final activeTurnMatches:Bool;
	public final hasPendingTriggerMailbox:Bool;
	public final interruptedMarkerEligible:Bool;
	public final secretProbe:String;

	public function new(requestId:String, turnId:String, terminalKind:ModelTurnLifecycleTerminalKind, terminalStopHookOutcome:ModelTerminalStopHookOutcome,
			samplingErrorTerminalOutcome:ModelSamplingErrorTerminalOutcome, lastAgentMessage:String, abortReason:String, taskCancellationRequested:Bool,
			rolloutFlushOk:Bool, activeTurnMatches:Bool, hasPendingTriggerMailbox:Bool, interruptedMarkerEligible:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.turnId = turnId == null ? "" : turnId;
		this.terminalKind = terminalKind == null ? ModelTurnLifecycleTerminalKind.Completed : terminalKind;
		this.terminalStopHookOutcome = terminalStopHookOutcome;
		this.samplingErrorTerminalOutcome = samplingErrorTerminalOutcome;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.abortReason = abortReason == null ? "" : abortReason;
		this.taskCancellationRequested = taskCancellationRequested;
		this.rolloutFlushOk = rolloutFlushOk;
		this.activeTurnMatches = activeTurnMatches;
		this.hasPendingTriggerMailbox = hasPendingTriggerMailbox;
		this.interruptedMarkerEligible = interruptedMarkerEligible;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
