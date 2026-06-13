package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnMerger {
	public static function mergeCases(
		baseTurns:Array<ThreadReadTurnSummary>,
		requests:Array<ThreadReadActiveTurnMergeRequest>
	):ThreadReadActiveTurnMergeReport {
		final outcomes:Array<ThreadReadActiveTurnMergeOutcome> = [];
		for (request in requests) {
			outcomes.push(reconstruct(baseTurns, request));
		}
		return new ThreadReadActiveTurnMergeReport(outcomes);
	}

	public static function reconstruct(
		baseTurns:Array<ThreadReadTurnSummary>,
		request:ThreadReadActiveTurnMergeRequest
	):ThreadReadActiveTurnMergeOutcome {
		if (!ThreadReadThreadStatus.isValid(request.loadedStatus)) {
			return ThreadReadActiveTurnMergeOutcome.failure("invalid_thread_status", "loadedStatus must be notLoaded, idle, systemError, or active");
		}

		final hasLiveInProgress = request.hasLiveRunningThread
			|| (request.activeTurn != null && request.activeTurn.status == ThreadReadTurnStatus.InProgress);
		final resolvedStatus = resolveThreadStatus(request.loadedStatus, hasLiveInProgress);
		final turns = cloneTurns(baseTurns);
		if (resolvedStatus != ThreadReadThreadStatus.Active) interruptStaleInProgress(turns);
		if (request.activeTurn != null) mergeActiveTurn(turns, request.activeTurn);
		return ThreadReadActiveTurnMergeOutcome.success(resolvedStatus, turns);
	}

	static function resolveThreadStatus(status:ThreadReadThreadStatus, hasLiveInProgress:Bool):ThreadReadThreadStatus {
		if (hasLiveInProgress && (status == ThreadReadThreadStatus.Idle || status == ThreadReadThreadStatus.NotLoaded)) {
			return ThreadReadThreadStatus.Active;
		}
		return status;
	}

	static function interruptStaleInProgress(turns:Array<ThreadReadTurnSummary>):Void {
		var i = 0;
		while (i < turns.length) {
			final turn = turns[i];
			if (turn.status == ThreadReadTurnStatus.InProgress) {
				turns[i] = new ThreadReadTurnSummary(turn.id, ThreadReadTurnStatus.Interrupted, turn.items);
			}
			i = i + 1;
		}
	}

	static function mergeActiveTurn(turns:Array<ThreadReadTurnSummary>, activeTurn:ThreadReadTurnSummary):Void {
		var i = turns.length - 1;
		while (i >= 0) {
			if (turns[i].id == activeTurn.id) turns.splice(i, 1);
			i = i - 1;
		}
		turns.push(activeTurn);
	}

	static function cloneTurns(turns:Array<ThreadReadTurnSummary>):Array<ThreadReadTurnSummary> {
		final out:Array<ThreadReadTurnSummary> = [];
		for (turn in turns) {
			final items:Array<ThreadReadTurnItemSummary> = [];
			for (item in turn.items) {
				items.push(item);
			}
			out.push(new ThreadReadTurnSummary(turn.id, turn.status, items));
		}
		return out;
	}
}
