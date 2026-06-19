package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadTurnStartGoalAccountingRequest {
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final turnId:String;
	public final collaborationMode:ThreadReadTurnStartCollaborationMode;
	public final tokenUsageAtTurnStart:Int;
	public final storedGoalLookupOutcomeKind:ThreadReadStoredGoalLookupOutcomeKind;
	public final storedGoalLookupErrorCode:String;
	public final storedGoal:ThreadGoal;
	public final storedGoalId:String;
	public final budgetLimitReportedGoalId:String;

	public function new(runtimeAvailable:Bool, runtimeEnabled:Bool, turnId:String, collaborationMode:ThreadReadTurnStartCollaborationMode,
			tokenUsageAtTurnStart:Int, storedGoalLookupOutcomeKind:ThreadReadStoredGoalLookupOutcomeKind, storedGoalLookupErrorCode:String,
			storedGoal:ThreadGoal, storedGoalId:String, budgetLimitReportedGoalId:String) {
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.turnId = turnId;
		this.collaborationMode = collaborationMode;
		this.tokenUsageAtTurnStart = tokenUsageAtTurnStart;
		this.storedGoalLookupOutcomeKind = storedGoalLookupOutcomeKind;
		this.storedGoalLookupErrorCode = storedGoalLookupErrorCode;
		this.storedGoal = storedGoal;
		this.storedGoalId = storedGoalId;
		this.budgetLimitReportedGoalId = budgetLimitReportedGoalId;
	}
}
