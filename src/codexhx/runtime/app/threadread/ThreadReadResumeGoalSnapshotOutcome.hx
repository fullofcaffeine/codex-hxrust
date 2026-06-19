package codexhx.runtime.app.threadread;

class ThreadReadResumeGoalSnapshotOutcome {
	public final ok:Bool;
	public final code:String;
	public final operation:ThreadReadTokenUsageReplayDeliveryOperation;
	public final snapshotDelivered:Bool;
	public final goalUpdated:Bool;
	public final goalCleared:Bool;
	public final skipped:Bool;
	public final sequence:String;
	public final notificationMethod:String;
	public final continuationIntent:ThreadReadResumeGoalContinuationIntent;
	public final pendingRequestsReplayPoint:String;
	public final message:String;

	function new(ok:Bool, code:String, operation:ThreadReadTokenUsageReplayDeliveryOperation, snapshotDelivered:Bool, goalUpdated:Bool, goalCleared:Bool,
			skipped:Bool, sequence:String, notificationMethod:String, continuationIntent:ThreadReadResumeGoalContinuationIntent,
			pendingRequestsReplayPoint:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.operation = operation;
		this.snapshotDelivered = snapshotDelivered;
		this.goalUpdated = goalUpdated;
		this.goalCleared = goalCleared;
		this.skipped = skipped;
		this.sequence = sequence;
		this.notificationMethod = notificationMethod;
		this.continuationIntent = continuationIntent;
		this.pendingRequestsReplayPoint = pendingRequestsReplayPoint;
		this.message = message;
	}

	public static function updated(operation:ThreadReadTokenUsageReplayDeliveryOperation, sequence:String,
			continuationIntent:ThreadReadResumeGoalContinuationIntent, pendingRequestsReplayPoint:String, message:String):ThreadReadResumeGoalSnapshotOutcome {
		return new ThreadReadResumeGoalSnapshotOutcome(true, "goal_snapshot_updated", operation, true, true, false, false, sequence, "thread/goal/updated",
			continuationIntent, pendingRequestsReplayPoint, message);
	}

	public static function cleared(operation:ThreadReadTokenUsageReplayDeliveryOperation, sequence:String,
			pendingRequestsReplayPoint:String):ThreadReadResumeGoalSnapshotOutcome {
		return new ThreadReadResumeGoalSnapshotOutcome(true, "goal_snapshot_cleared", operation, true, false, true, false, sequence, "thread/goal/cleared",
			ThreadReadResumeGoalContinuationIntent.None, pendingRequestsReplayPoint,
			"no stored goal was available; upstream emits a cleared snapshot and no goal continuation");
	}

	public static function makeSkipped(operation:ThreadReadTokenUsageReplayDeliveryOperation, code:String, sequence:String,
			message:String):ThreadReadResumeGoalSnapshotOutcome {
		return new ThreadReadResumeGoalSnapshotOutcome(true, code, operation, false, false, false, true, sequence, "none",
			ThreadReadResumeGoalContinuationIntent.None, "none", message);
	}

	public static function failure(operation:ThreadReadTokenUsageReplayDeliveryOperation, code:String, message:String):ThreadReadResumeGoalSnapshotOutcome {
		return new ThreadReadResumeGoalSnapshotOutcome(false, code, operation, false, false, false, false, "none", "none",
			ThreadReadResumeGoalContinuationIntent.None, "none", message);
	}

	public function summary():String {
		return "operation=" + operation + ";ok=" + (ok ? "true" : "false") + ";code=" + code + ";snapshotDelivered="
			+ (snapshotDelivered ? "true" : "false") + ";goalUpdated=" + (goalUpdated ? "true" : "false") + ";goalCleared="
			+ (goalCleared ? "true" : "false") + ";skipped=" + (skipped ? "true" : "false") + ";notification=" + notificationMethod + ";sequence=" + sequence
			+ ";pendingRequestsReplayPoint=" + pendingRequestsReplayPoint + ";continuationIntent=" + continuationIntent + ";message=" + message;
	}
}
