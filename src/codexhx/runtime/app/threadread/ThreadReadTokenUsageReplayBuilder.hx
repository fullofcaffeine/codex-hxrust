package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageReplayBuilder {
	public static function buildCases(requests:Array<Null<ThreadReadTokenUsageReplayRequest>>):ThreadReadTokenUsageReplayReport {
		final outcomes:Array<ThreadReadTokenUsageReplayOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadTokenUsageReplayReport(outcomes);
	}

	public static function build(request:Null<ThreadReadTokenUsageReplayRequest>):ThreadReadTokenUsageReplayOutcome {
		if (request == null) {
			return ThreadReadTokenUsageReplayOutcome.failure("invalid_thread_id", "thread id must be a valid upstream thread UUID");
		}
		if (request.ownerOutcome == null || !request.ownerOutcome.ok) {
			final ownerCode = request.ownerOutcome == null ? "missing_owner" : request.ownerOutcome.code;
			return ThreadReadTokenUsageReplayOutcome.failure("missing_owner_turn", "cannot replay token usage without resolved owner turn: " + ownerCode);
		}
		if (request.tokenUsage == null) {
			return ThreadReadTokenUsageReplayOutcome.failure("missing_token_usage", "conversation has no persisted token usage to replay");
		}
		if (!request.tokenUsage.isValid()) {
			return ThreadReadTokenUsageReplayOutcome.failure("invalid_token_usage", "token usage counters and model context window must be non-negative");
		}
		return ThreadReadTokenUsageReplayOutcome.emitted(new ThreadReadTokenUsageReplayNotification(request.threadIdString(), request.ownerOutcome.turnId,
			request.tokenUsage));
	}
}
