package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadIdleGoalProgressAccountingRequest {
	public final eventId:String;
	public final idleProgressSnapshotAvailable:Bool;
	public final snapshotExpectedGoalId:String;
	public final snapshotTimeDeltaSeconds:Int;
	public final previousStatus:String;
	public final dbOutcomeKind:ThreadReadGoalAccountingDbOutcomeKind;
	public final dbErrorCode:String;
	public final updatedGoal:ThreadGoal;
	public final updatedGoalId:String;
	public final disposition:ThreadReadGoalAccountingDisposition;

	public function new(
		eventId:String,
		idleProgressSnapshotAvailable:Bool,
		snapshotExpectedGoalId:String,
		snapshotTimeDeltaSeconds:Int,
		previousStatus:String,
		dbOutcomeKind:ThreadReadGoalAccountingDbOutcomeKind,
		dbErrorCode:String,
		updatedGoal:ThreadGoal,
		updatedGoalId:String,
		disposition:ThreadReadGoalAccountingDisposition
	) {
		this.eventId = eventId;
		this.idleProgressSnapshotAvailable = idleProgressSnapshotAvailable;
		this.snapshotExpectedGoalId = snapshotExpectedGoalId;
		this.snapshotTimeDeltaSeconds = snapshotTimeDeltaSeconds;
		this.previousStatus = previousStatus;
		this.dbOutcomeKind = dbOutcomeKind;
		this.dbErrorCode = dbErrorCode;
		this.updatedGoal = updatedGoal;
		this.updatedGoalId = updatedGoalId;
		this.disposition = disposition;
	}
}
