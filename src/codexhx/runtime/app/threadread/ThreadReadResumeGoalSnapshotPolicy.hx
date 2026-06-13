package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadResumeGoalSnapshotPolicy {
	public static function planCases(requests:Array<ThreadReadResumeGoalSnapshotRequest>):ThreadReadResumeGoalSnapshotReport {
		final outcomes:Array<ThreadReadResumeGoalSnapshotOutcome> = [];
		for (request in requests) {
			outcomes.push(plan(request));
		}
		return new ThreadReadResumeGoalSnapshotReport(outcomes);
	}

	public static function plan(request:ThreadReadResumeGoalSnapshotRequest):ThreadReadResumeGoalSnapshotOutcome {
		if (!request.responseReady) {
			return ThreadReadResumeGoalSnapshotOutcome.failure(
				request.operation,
				"response_not_ready",
				"resume goal snapshot must be ordered after the JSON-RPC response"
			);
		}
		if (request.tokenUsageDelivery == null || !request.tokenUsageDelivery.ok) {
			return ThreadReadResumeGoalSnapshotOutcome.failure(
				request.operation,
				"token_usage_delivery_not_settled",
				"resume goal snapshot waits for token usage replay policy to settle"
			);
		}
		if (request.operation == ThreadReadTokenUsageReplayDeliveryOperation.Fork) {
			return ThreadReadResumeGoalSnapshotOutcome.makeSkipped(
				request.operation,
				"skipped_fork_has_no_resume_goal_snapshot",
				baseSequence(request),
				"upstream fork delivery replays token usage but does not emit a resume goal snapshot"
			);
		}
		if (!request.goalsFeatureEnabled) {
			return ThreadReadResumeGoalSnapshotOutcome.makeSkipped(
				request.operation,
				"skipped_goals_feature_disabled",
				baseSequence(request),
				"goals feature disabled; upstream returns before snapshot and idle continuation"
			);
		}
		if (!request.stateDbAvailable) {
			return ThreadReadResumeGoalSnapshotOutcome.makeSkipped(
				request.operation,
				"skipped_state_db_unavailable",
				baseSequence(request),
				"state db unavailable when reading thread goal for resume snapshot"
			);
		}
		final pendingPoint = request.pendingRequestsReplayAfterSnapshot ? "after_goal_snapshot" : "none";
		if (request.goal == null) {
			return ThreadReadResumeGoalSnapshotOutcome.cleared(
				request.operation,
				appendStep(baseSequence(request), "thread/goal/cleared"),
				pendingPoint
			);
		}
		final intent = continuationIntentForStatus(request.goal.status);
		return ThreadReadResumeGoalSnapshotOutcome.updated(
			request.operation,
			appendStep(baseSequence(request), "thread/goal/updated"),
			intent,
			pendingPoint,
			"stored goal snapshot delivered with status=" + request.goal.status
		);
	}

	static function continuationIntentForStatus(status:String):ThreadReadResumeGoalContinuationIntent {
		if (status == ThreadGoalStatus.Active) return ThreadReadResumeGoalContinuationIntent.EmitIdleLifecycle;
		if (ThreadGoalStatus.isTerminal(status)) return ThreadReadResumeGoalContinuationIntent.SnapshotOnly;
		return ThreadReadResumeGoalContinuationIntent.SnapshotOnly;
	}

	static function baseSequence(request:ThreadReadResumeGoalSnapshotRequest):String {
		if (request.tokenUsageDelivery != null && request.tokenUsageDelivery.sequence.length > 0) {
			return request.tokenUsageDelivery.sequence;
		}
		return "response";
	}

	static function appendStep(sequence:String, step:String):String {
		if (sequence.length == 0 || sequence == "none") return step;
		return sequence + "->" + step;
	}
}
