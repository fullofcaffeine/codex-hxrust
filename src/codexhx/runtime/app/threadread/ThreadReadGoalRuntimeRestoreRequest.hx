package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadGoalRuntimeRestoreRequest {
	public final runtimePresent:Bool;
	public final runtimeEnabled:Bool;
	public final stateReadOk:Bool;
	public final stateReadErrorCode:String;
	public final storedGoal:ThreadGoal;
	public final storedGoalId:String;
	public final previousActiveGoalId:String;

	public function new(runtimePresent:Bool, runtimeEnabled:Bool, stateReadOk:Bool, stateReadErrorCode:String, storedGoal:ThreadGoal, storedGoalId:String,
			previousActiveGoalId:String) {
		this.runtimePresent = runtimePresent;
		this.runtimeEnabled = runtimeEnabled;
		this.stateReadOk = stateReadOk;
		this.stateReadErrorCode = stateReadErrorCode;
		this.storedGoal = storedGoal;
		this.storedGoalId = storedGoalId;
		this.previousActiveGoalId = previousActiveGoalId;
	}
}
