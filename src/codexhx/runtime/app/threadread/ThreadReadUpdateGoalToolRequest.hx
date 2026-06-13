package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadUpdateGoalToolRequest {
	public final threadId:String;
	public final turnId:String;
	public final callId:String;
	public final argumentsJson:String;
	public final accountingOutcomeKind:ThreadReadUpdateGoalToolAccountingOutcomeKind;
	public final accountingErrorMessage:String;
	public final metricsReadOutcomeKind:ThreadReadUpdateGoalToolMetricsReadOutcomeKind;
	public final metricsReadErrorMessage:String;
	public final previousStatus:String;
	public final updateOutcomeKind:ThreadReadUpdateGoalToolUpdateOutcomeKind;
	public final updateErrorMessage:String;
	public final clearedTurnId:String;
	public final updatedGoal:ThreadGoal;

	public function new(
		threadId:String,
		turnId:String,
		callId:String,
		argumentsJson:String,
		accountingOutcomeKind:ThreadReadUpdateGoalToolAccountingOutcomeKind,
		accountingErrorMessage:String,
		metricsReadOutcomeKind:ThreadReadUpdateGoalToolMetricsReadOutcomeKind,
		metricsReadErrorMessage:String,
		previousStatus:String,
		updateOutcomeKind:ThreadReadUpdateGoalToolUpdateOutcomeKind,
		updateErrorMessage:String,
		clearedTurnId:String,
		updatedGoal:ThreadGoal
	) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.callId = callId;
		this.argumentsJson = argumentsJson;
		this.accountingOutcomeKind = accountingOutcomeKind;
		this.accountingErrorMessage = accountingErrorMessage;
		this.metricsReadOutcomeKind = metricsReadOutcomeKind;
		this.metricsReadErrorMessage = metricsReadErrorMessage;
		this.previousStatus = previousStatus;
		this.updateOutcomeKind = updateOutcomeKind;
		this.updateErrorMessage = updateErrorMessage;
		this.clearedTurnId = clearedTurnId;
		this.updatedGoal = updatedGoal;
	}
}
