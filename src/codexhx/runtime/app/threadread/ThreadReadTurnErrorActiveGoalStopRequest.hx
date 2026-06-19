package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadTurnErrorActiveGoalStopRequest {
	public final turnId:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final errorKind:ThreadReadTurnErrorKind;
	public final goalStatePermitOk:Bool;
	public final currentTurnIsActiveGoal:Bool;
	public final accountingOutcome:ThreadReadActiveGoalProgressAccountingOutcome;
	public final storedGoalLookupOutcomeKind:ThreadReadStoredGoalLookupOutcomeKind;
	public final storedGoalLookupErrorCode:String;
	public final storedGoal:ThreadGoal;
	public final storedGoalId:String;

	public function new(turnId:String, runtimeAvailable:Bool, runtimeEnabled:Bool, errorKind:ThreadReadTurnErrorKind, goalStatePermitOk:Bool,
			currentTurnIsActiveGoal:Bool, accountingOutcome:ThreadReadActiveGoalProgressAccountingOutcome,
			storedGoalLookupOutcomeKind:ThreadReadStoredGoalLookupOutcomeKind, storedGoalLookupErrorCode:String, storedGoal:ThreadGoal, storedGoalId:String) {
		this.turnId = turnId;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.errorKind = errorKind;
		this.goalStatePermitOk = goalStatePermitOk;
		this.currentTurnIsActiveGoal = currentTurnIsActiveGoal;
		this.accountingOutcome = accountingOutcome;
		this.storedGoalLookupOutcomeKind = storedGoalLookupOutcomeKind;
		this.storedGoalLookupErrorCode = storedGoalLookupErrorCode;
		this.storedGoal = storedGoal;
		this.storedGoalId = storedGoalId;
	}
}
