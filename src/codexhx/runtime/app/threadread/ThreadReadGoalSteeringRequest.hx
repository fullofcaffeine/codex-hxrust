package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadGoalSteeringRequest {
	public final kind:ThreadReadGoalSteeringItemKind;
	public final goal:ThreadGoal;
	public final continuationOutcome:ThreadReadResumeIdleContinuationOutcome;
	public final objectiveChanged:Bool;

	public function new(kind:ThreadReadGoalSteeringItemKind, goal:ThreadGoal, continuationOutcome:ThreadReadResumeIdleContinuationOutcome,
			objectiveChanged:Bool) {
		this.kind = kind;
		this.goal = goal;
		this.continuationOutcome = continuationOutcome;
		this.objectiveChanged = objectiveChanged;
	}
}
