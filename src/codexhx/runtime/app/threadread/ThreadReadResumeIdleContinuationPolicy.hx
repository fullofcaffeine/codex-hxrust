package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;

class ThreadReadResumeIdleContinuationPolicy {
	public static function planCases(requests:Array<ThreadReadResumeIdleContinuationRequest>):ThreadReadResumeIdleContinuationReport {
		final outcomes:Array<ThreadReadResumeIdleContinuationOutcome> = [];
		for (request in requests) {
			outcomes.push(plan(request));
		}
		return new ThreadReadResumeIdleContinuationReport(outcomes);
	}

	public static function plan(request:ThreadReadResumeIdleContinuationRequest):ThreadReadResumeIdleContinuationOutcome {
		if (request.snapshotOutcome == null || !request.snapshotOutcome.ok) {
			return ThreadReadResumeIdleContinuationOutcome.failure(
				request.operation,
				"snapshot_not_settled",
				"resume idle lifecycle waits for response and goal snapshot ordering to settle"
			);
		}
		if (request.operation == ThreadReadTokenUsageReplayDeliveryOperation.Fork) {
			return ThreadReadResumeIdleContinuationOutcome.makeSkipped(
				request.operation,
				"skipped_fork_has_no_resume_idle_lifecycle",
				baseSequence(request),
				"fork is not routed through resume goal snapshot idle continuation"
			);
		}
		if (request.snapshotOutcome.code == "skipped_goals_feature_disabled") {
			return ThreadReadResumeIdleContinuationOutcome.makeSkipped(
				request.operation,
				"skipped_goals_feature_disabled",
				baseSequence(request),
				"goals feature disabled; upstream returns before resume idle lifecycle"
			);
		}
		if (request.activeTurnPresent) {
			return ThreadReadResumeIdleContinuationOutcome.makeSkipped(
				request.operation,
				"skipped_active_turn_present",
				baseSequence(request),
				"thread idle lifecycle is not emitted while an active turn is present"
			);
		}
		if (request.triggerMailboxPending) {
			return ThreadReadResumeIdleContinuationOutcome.makeSkipped(
				request.operation,
				"skipped_trigger_mailbox_pending",
				baseSequence(request),
				"thread idle lifecycle waits for trigger-turn mailbox work to drain"
			);
		}

		final idleSequence = appendStep(sequenceBeforeIdle(request), "thread/idle");
		if (request.goal == null) {
			return ThreadReadResumeIdleContinuationOutcome.makeIdleOnly(
				request.operation,
				"snapshot_only_no_goal",
				idleSequence,
				true,
				"no active goal runtime continuation is available after cleared snapshot"
			);
		}
		if (request.goal.status != ThreadGoalStatus.Active) {
			return ThreadReadResumeIdleContinuationOutcome.makeIdleOnly(
				request.operation,
				"snapshot_only_goal_not_active",
				idleSequence,
				true,
				"goal status " + request.goal.status + " clears active goal accounting and does not continue"
			);
		}
		if (!request.toolsVisible) {
			return ThreadReadResumeIdleContinuationOutcome.makeIdleOnly(
				request.operation,
				"skipped_tools_not_visible",
				idleSequence,
				true,
				"goal runtime clears active goal when continuation tools are not visible"
			);
		}
		if (!request.threadManagerAvailable) {
			return ThreadReadResumeIdleContinuationOutcome.makeIdleOnly(
				request.operation,
				"skipped_thread_manager_unavailable",
				idleSequence,
				false,
				"goal continuation skipped because thread manager is unavailable"
			);
		}
		if (!request.liveThreadAvailable) {
			return ThreadReadResumeIdleContinuationOutcome.makeIdleOnly(
				request.operation,
				"skipped_live_thread_unavailable",
				idleSequence,
				false,
				"goal continuation skipped because live thread is unavailable"
			);
		}

		final continuationSequence = appendStep(idleSequence, "goal/continue");
		if (!request.automaticStartAccepted) {
			return ThreadReadResumeIdleContinuationOutcome.makeRejected(
				request.operation,
				continuationSequence
			);
		}
		return ThreadReadResumeIdleContinuationOutcome.makeStarted(
			request.operation,
			appendStep(continuationSequence, "turn/start")
		);
	}

	static function sequenceBeforeIdle(request:ThreadReadResumeIdleContinuationRequest):String {
		final sequence = baseSequence(request);
		if (request.snapshotOutcome != null && request.snapshotOutcome.pendingRequestsReplayPoint == "after_goal_snapshot") {
			return appendStep(sequence, "pending/request/replay");
		}
		return sequence;
	}

	static function baseSequence(request:ThreadReadResumeIdleContinuationRequest):String {
		if (request.snapshotOutcome != null && request.snapshotOutcome.sequence.length > 0) {
			return request.snapshotOutcome.sequence;
		}
		return "response";
	}

	static function appendStep(sequence:String, step:String):String {
		if (sequence.length == 0 || sequence == "none") return step;
		return sequence + "->" + step;
	}
}
