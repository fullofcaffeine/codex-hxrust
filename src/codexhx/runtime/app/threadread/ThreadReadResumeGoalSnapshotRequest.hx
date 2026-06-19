package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadResumeGoalSnapshotRequest {
	public final operation:ThreadReadTokenUsageReplayDeliveryOperation;
	public final responseReady:Bool;
	public final goalsFeatureEnabled:Bool;
	public final stateDbAvailable:Bool;
	public final pendingRequestsReplayAfterSnapshot:Bool;
	public final tokenUsageDelivery:ThreadReadTokenUsageReplayDeliveryOutcome;
	public final goal:ThreadGoal;

	public function new(operation:ThreadReadTokenUsageReplayDeliveryOperation, responseReady:Bool, goalsFeatureEnabled:Bool, stateDbAvailable:Bool,
			pendingRequestsReplayAfterSnapshot:Bool, tokenUsageDelivery:ThreadReadTokenUsageReplayDeliveryOutcome, goal:ThreadGoal) {
		this.operation = operation;
		this.responseReady = responseReady;
		this.goalsFeatureEnabled = goalsFeatureEnabled;
		this.stateDbAvailable = stateDbAvailable;
		this.pendingRequestsReplayAfterSnapshot = pendingRequestsReplayAfterSnapshot;
		this.tokenUsageDelivery = tokenUsageDelivery;
		this.goal = goal;
	}
}
