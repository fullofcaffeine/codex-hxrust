package codexhx.runtime.app.threadread;

enum abstract ThreadReadTryStartTurnIfIdleRejectionReason(String) from String to String {
	var None = "none";
	var PendingTriggerTurn = "pending_trigger_turn";
	var PlanMode = "plan_mode";
	var Busy = "busy";
}
