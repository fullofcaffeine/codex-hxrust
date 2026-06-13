package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadBudgetLimitGoalSteeringRequest {
	public final progressOk:Bool;
	public final progressAvailable:Bool;
	public final progressErrorCode:String;
	public final goal:ThreadGoal;
	public final goalId:String;
	public final budgetLimitAlreadyReported:Bool;
	public final threadManagerAvailable:Bool;
	public final liveThreadAvailable:Bool;
	public final activeTurnRunning:Bool;

	public function new(
		progressOk:Bool,
		progressAvailable:Bool,
		progressErrorCode:String,
		goal:ThreadGoal,
		goalId:String,
		budgetLimitAlreadyReported:Bool,
		threadManagerAvailable:Bool,
		liveThreadAvailable:Bool,
		activeTurnRunning:Bool
	) {
		this.progressOk = progressOk;
		this.progressAvailable = progressAvailable;
		this.progressErrorCode = progressErrorCode;
		this.goal = goal;
		this.goalId = goalId;
		this.budgetLimitAlreadyReported = budgetLimitAlreadyReported;
		this.threadManagerAvailable = threadManagerAvailable;
		this.liveThreadAvailable = liveThreadAvailable;
		this.activeTurnRunning = activeTurnRunning;
	}
}
