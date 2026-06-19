package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageOwnerResolver {
	public static function resolveCases(requests:Array<ThreadReadTokenUsageOwnerRequest>):ThreadReadTokenUsageOwnerReport {
		final outcomes:Array<ThreadReadTokenUsageOwnerOutcome> = [];
		for (request in requests) {
			outcomes.push(resolve(request));
		}
		return new ThreadReadTokenUsageOwnerReport(outcomes);
	}

	public static function resolve(request:ThreadReadTokenUsageOwnerRequest):ThreadReadTokenUsageOwnerOutcome {
		if (request.turns.length == 0) {
			return ThreadReadTokenUsageOwnerOutcome.failure("empty_thread", ThreadReadTokenUsageOwnerReason.EmptyThread,
				"cannot attribute replayed token usage without reconstructed turns");
		}

		final owner = request.ownerHint;
		if (owner != null) {
			final explicitIndex = findTurnIndex(request.turns, owner.idString());
			if (explicitIndex >= 0) {
				return ThreadReadTokenUsageOwnerOutcome.selected(owner.idString(), explicitIndex, ThreadReadTokenUsageOwnerReason.ExplicitOwner);
			}
			if (owner.hasPosition && owner.position >= 0 && owner.position < request.turns.length) {
				final rebuilt = request.turns[owner.position];
				return ThreadReadTokenUsageOwnerOutcome.selected(rebuilt.id, owner.position, ThreadReadTokenUsageOwnerReason.RebuiltPosition);
			}
		}

		var i = request.turns.length - 1;
		while (i >= 0) {
			final turn = request.turns[i];
			if (turn.status == ThreadReadTurnStatus.Completed || turn.status == ThreadReadTurnStatus.Failed) {
				return ThreadReadTokenUsageOwnerOutcome.selected(turn.id, i, ThreadReadTokenUsageOwnerReason.LatestCompletedOrFailed);
			}
			i = i - 1;
		}

		final lastIndex = request.turns.length - 1;
		return ThreadReadTokenUsageOwnerOutcome.selected(request.turns[lastIndex].id, lastIndex, ThreadReadTokenUsageOwnerReason.LatestTurn);
	}

	static function findTurnIndex(turns:Array<ThreadReadTurnSummary>, turnId:String):Int {
		var i = 0;
		while (i < turns.length) {
			if (turns[i].id == turnId)
				return i;
			i = i + 1;
		}
		return -1;
	}
}
