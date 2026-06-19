package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadResumeIdleContinuationRequest {
	public final operation:ThreadReadTokenUsageReplayDeliveryOperation;
	public final snapshotOutcome:ThreadReadResumeGoalSnapshotOutcome;
	public final activeTurnPresent:Bool;
	public final triggerMailboxPending:Bool;
	public final toolsVisible:Bool;
	public final threadManagerAvailable:Bool;
	public final liveThreadAvailable:Bool;
	public final automaticStartAccepted:Bool;
	public final goal:ThreadGoal;

	public function new(operation:ThreadReadTokenUsageReplayDeliveryOperation, snapshotOutcome:ThreadReadResumeGoalSnapshotOutcome, activeTurnPresent:Bool,
			triggerMailboxPending:Bool, toolsVisible:Bool, threadManagerAvailable:Bool, liveThreadAvailable:Bool, automaticStartAccepted:Bool,
			goal:ThreadGoal) {
		this.operation = operation;
		this.snapshotOutcome = snapshotOutcome;
		this.activeTurnPresent = activeTurnPresent;
		this.triggerMailboxPending = triggerMailboxPending;
		this.toolsVisible = toolsVisible;
		this.threadManagerAvailable = threadManagerAvailable;
		this.liveThreadAvailable = liveThreadAvailable;
		this.automaticStartAccepted = automaticStartAccepted;
		this.goal = goal;
	}
}
