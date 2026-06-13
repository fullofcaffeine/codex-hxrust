package codexhx.runtime.app.threadread;

class ThreadReadGoalTokenUsageRecordPolicy {
	public static function buildCases(requests:Array<ThreadReadGoalTokenUsageRecordRequest>):ThreadReadGoalTokenUsageRecordReport {
		final outcomes:Array<ThreadReadGoalTokenUsageRecordOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadGoalTokenUsageRecordReport(outcomes);
	}

	public static function build(request:ThreadReadGoalTokenUsageRecordRequest):ThreadReadGoalTokenUsageRecordOutcome {
		if (!request.runtimeAvailable) {
			return ThreadReadGoalTokenUsageRecordOutcome.runtimeMissing(request.turnStoreLevelId, request.currentTurnId);
		}
		if (!request.runtimeEnabled) {
			return ThreadReadGoalTokenUsageRecordOutcome.runtimeDisabled(request.turnStoreLevelId, request.currentTurnId);
		}
		if (!request.turnKnown) {
			return ThreadReadGoalTokenUsageRecordOutcome.unknownTurn(request.turnStoreLevelId, request.currentTurnId);
		}

		final delta = goalTokenDeltaSinceLastAccounting(request.lastAccountedUsage, request.totalUsage);
		final ignoredReasoning = reasoningDelta(request.lastAccountedUsage, request.totalUsage) > 0;
		final ignoredTotal = totalDelta(request.lastAccountedUsage, request.totalUsage) != delta;
		if (!request.accountTokens) {
			return ThreadReadGoalTokenUsageRecordOutcome.notAccounted(
				"token_accounting_disabled_skip",
				request.turnStoreLevelId,
				request.currentTurnId,
				false,
				delta,
				ignoredReasoning,
				ignoredTotal
			);
		}
		if (delta <= 0) {
			return ThreadReadGoalTokenUsageRecordOutcome.notAccounted(
				"non_positive_delta_skip",
				request.turnStoreLevelId,
				request.currentTurnId,
				true,
				delta,
				ignoredReasoning,
				ignoredTotal
			);
		}
		final otherDelta = request.otherUnflushedTokenDelta > 0 ? request.otherUnflushedTokenDelta : 0;
		return ThreadReadGoalTokenUsageRecordOutcome.recordedDelta(
			request.turnStoreLevelId,
			request.currentTurnId,
			delta,
			delta + otherDelta,
			ignoredReasoning,
			ignoredTotal
		);
	}

	static function goalTokenDeltaSinceLastAccounting(last:ThreadReadTokenUsageBreakdown, current:ThreadReadTokenUsageBreakdown):Int {
		final inputDelta = positiveDelta(last.inputTokens, current.inputTokens);
		final cachedDelta = positiveDelta(last.cachedInputTokens, current.cachedInputTokens);
		final outputDelta = positiveDelta(last.outputTokens, current.outputTokens);
		final nonCachedInputDelta = inputDelta > cachedDelta ? inputDelta - cachedDelta : 0;
		return nonCachedInputDelta + outputDelta;
	}

	static function reasoningDelta(last:ThreadReadTokenUsageBreakdown, current:ThreadReadTokenUsageBreakdown):Int {
		return positiveDelta(last.reasoningOutputTokens, current.reasoningOutputTokens);
	}

	static function totalDelta(last:ThreadReadTokenUsageBreakdown, current:ThreadReadTokenUsageBreakdown):Int {
		return positiveDelta(last.totalTokens, current.totalTokens);
	}

	static function positiveDelta(previous:Int, current:Int):Int {
		return current > previous ? current - previous : 0;
	}
}
