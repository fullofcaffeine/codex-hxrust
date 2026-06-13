package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadActiveGoalProgressAccountingRequest {
	public final turnId:String;
	public final eventId:String;
	public final progressSnapshotAvailable:Bool;
	public final snapshotExpectedGoalId:String;
	public final snapshotTimeDeltaSeconds:Int;
	public final snapshotTokenDelta:Int;
	public final previousStatus:String;
	public final dbOutcomeKind:ThreadReadGoalAccountingDbOutcomeKind;
	public final dbErrorCode:String;
	public final updatedGoal:ThreadGoal;
	public final updatedGoalId:String;
	public final disposition:ThreadReadGoalAccountingDisposition;

	public function new(
		turnId:String,
		eventId:String,
		progressSnapshotAvailable:Bool,
		snapshotExpectedGoalId:String,
		snapshotTimeDeltaSeconds:Int,
		snapshotTokenDelta:Int,
		previousStatus:String,
		dbOutcomeKind:ThreadReadGoalAccountingDbOutcomeKind,
		dbErrorCode:String,
		updatedGoal:ThreadGoal,
		updatedGoalId:String,
		disposition:ThreadReadGoalAccountingDisposition
	) {
		this.turnId = turnId;
		this.eventId = eventId;
		this.progressSnapshotAvailable = progressSnapshotAvailable;
		this.snapshotExpectedGoalId = snapshotExpectedGoalId;
		this.snapshotTimeDeltaSeconds = snapshotTimeDeltaSeconds;
		this.snapshotTokenDelta = snapshotTokenDelta;
		this.previousStatus = previousStatus;
		this.dbOutcomeKind = dbOutcomeKind;
		this.dbErrorCode = dbErrorCode;
		this.updatedGoal = updatedGoal;
		this.updatedGoalId = updatedGoalId;
		this.disposition = disposition;
	}
}
