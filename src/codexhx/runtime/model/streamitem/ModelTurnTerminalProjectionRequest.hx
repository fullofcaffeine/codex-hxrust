package codexhx.runtime.model.streamitem;

class ModelTurnTerminalProjectionRequest {
	public final requestId:String;
	public final threadId:String;
	public final turnId:String;
	public final lifecycleOutcome:ModelTurnLifecycleOutcome;
	public final eventKind:ModelTurnTerminalProjectionEventKind;
	public final priorTurnErrorMessage:String;
	public final lastAgentMessageOverride:String;
	public final abortReason:String;
	public final pendingInterruptRequest:Bool;
	public final fromReplay:Bool;
	public final hasQueuedFollowUp:Bool;
	public final activeGoalContinuing:Bool;
	public final sawCopySourceThisTurn:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		threadId:String,
		turnId:String,
		lifecycleOutcome:ModelTurnLifecycleOutcome,
		eventKind:ModelTurnTerminalProjectionEventKind,
		priorTurnErrorMessage:String,
		lastAgentMessageOverride:String,
		abortReason:String,
		pendingInterruptRequest:Bool,
		fromReplay:Bool,
		hasQueuedFollowUp:Bool,
		activeGoalContinuing:Bool,
		sawCopySourceThisTurn:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.threadId = threadId == null ? "" : threadId;
		this.turnId = turnId == null ? "" : turnId;
		this.lifecycleOutcome = lifecycleOutcome;
		this.eventKind = eventKind == null ? ModelTurnTerminalProjectionEventKind.TurnComplete : eventKind;
		this.priorTurnErrorMessage = priorTurnErrorMessage == null ? "" : priorTurnErrorMessage;
		this.lastAgentMessageOverride = lastAgentMessageOverride == null ? "" : lastAgentMessageOverride;
		this.abortReason = abortReason == null ? "" : abortReason;
		this.pendingInterruptRequest = pendingInterruptRequest;
		this.fromReplay = fromReplay;
		this.hasQueuedFollowUp = hasQueuedFollowUp;
		this.activeGoalContinuing = activeGoalContinuing;
		this.sawCopySourceThisTurn = sawCopySourceThisTurn;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
