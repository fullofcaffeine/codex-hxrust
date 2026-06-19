package codexhx.runtime.app.threadread;

class ThreadReadTryStartTurnIfIdleRequest {
	public final steeringOutcome:ThreadReadGoalSteeringOutcome;
	public final inputEmpty:Bool;
	public final pendingTriggerTurnBeforeReservation:Bool;
	public final collaborationPlanModeBeforeReservation:Bool;
	public final activeTaskKind:ThreadReadTryStartTurnIfIdleActiveTaskKind;
	public final pendingTriggerTurnAfterReservation:Bool;
	public final collaborationPlanModeAfterTurnContext:Bool;
	public final pendingTriggerTurnAfterTurnContext:Bool;
	public final reservationLostBeforeStart:Bool;

	public function new(steeringOutcome:ThreadReadGoalSteeringOutcome, inputEmpty:Bool, pendingTriggerTurnBeforeReservation:Bool,
			collaborationPlanModeBeforeReservation:Bool, activeTaskKind:ThreadReadTryStartTurnIfIdleActiveTaskKind, pendingTriggerTurnAfterReservation:Bool,
			collaborationPlanModeAfterTurnContext:Bool, pendingTriggerTurnAfterTurnContext:Bool, reservationLostBeforeStart:Bool) {
		this.steeringOutcome = steeringOutcome;
		this.inputEmpty = inputEmpty;
		this.pendingTriggerTurnBeforeReservation = pendingTriggerTurnBeforeReservation;
		this.collaborationPlanModeBeforeReservation = collaborationPlanModeBeforeReservation;
		this.activeTaskKind = activeTaskKind;
		this.pendingTriggerTurnAfterReservation = pendingTriggerTurnAfterReservation;
		this.collaborationPlanModeAfterTurnContext = collaborationPlanModeAfterTurnContext;
		this.pendingTriggerTurnAfterTurnContext = pendingTriggerTurnAfterTurnContext;
		this.reservationLostBeforeStart = reservationLostBeforeStart;
	}
}
