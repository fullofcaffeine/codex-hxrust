package codexhx.runtime.model.streamitem;

class ModelThreadSnapshotSessionRefreshPolicy {
	public static function apply(request:ModelThreadSnapshotSessionRefreshRequest):ModelThreadSnapshotSessionRefreshOutcome {
		if (request == null)
			return failure("", "", "missing refreshed snapshot session request");

		final snapshotSessionCwdAfter = request.refreshedSessionCwd;
		final storeSessionCwdAfter = request.refreshedSessionCwd;
		final resumedTurnCount = request.resumedTurns.length;
		final userMessageCount = countUserMessages(request.resumedTurns);
		final activeTurnIdAfter = latestInProgressTurnId(request.resumedTurns);
		final snapshotSessionReplaced = request.snapshotSessionCwdBefore != request.refreshedSessionCwd
			&& snapshotSessionCwdAfter == request.refreshedSessionCwd;
		final storeSessionReplaced = request.storeSessionCwdBefore != request.refreshedSessionCwd
			&& storeSessionCwdAfter == request.refreshedSessionCwd;
		final snapshotTurnsReplaced = request.snapshotTurnCountBefore != resumedTurnCount;
		final storeTurnsReplaced = request.storeTurnCountBefore != resumedTurnCount;
		final storeSnapshotMatchesRefreshedSnapshot = snapshotSessionCwdAfter == storeSessionCwdAfter
			&& resumedTurnCount == request.resumedTurns.length;
		final bufferRebasedAfterRefresh = request.survivingBufferEventCount <= request.bufferEventCountBefore;
		final refreshedCwdPreserved = snapshotSessionCwdAfter == request.refreshedSessionCwd
			&& storeSessionCwdAfter == request.refreshedSessionCwd;
		final resumedTurnsPersisted = resumedTurnCount > 0 && snapshotTurnsReplaced && storeTurnsReplaced;
		final activeTurnRestoredFromResumedTurns = activeTurnIdAfter.length > 0;
		final ok = request.threadId.length > 0
			&& refreshedCwdPreserved
			&& snapshotSessionReplaced
			&& storeSessionReplaced
			&& snapshotTurnsReplaced
			&& storeTurnsReplaced
			&& storeSnapshotMatchesRefreshedSnapshot
			&& bufferRebasedAfterRefresh
			&& resumedTurnsPersisted;

		return new ModelThreadSnapshotSessionRefreshOutcome({
			ok: ok,
			code: ok ? "thread_snapshot_session_refresh_modeled" : "thread_snapshot_session_refresh_blocked",
			requestId: request.requestId,
			threadId: request.threadId,
			decisionKind: ok ? ModelThreadSnapshotSessionRefreshDecisionKind.RefreshedSnapshotPersisted : ModelThreadSnapshotSessionRefreshDecisionKind.RefreshedSnapshotBlocked,
			snapshotSessionCwdAfter: snapshotSessionCwdAfter,
			storeSessionCwdAfter: storeSessionCwdAfter,
			snapshotTurnCountAfter: resumedTurnCount,
			storeTurnCountAfter: resumedTurnCount,
			resumedTurnCount: resumedTurnCount,
			userMessageCount: userMessageCount,
			activeTurnIdAfter: activeTurnIdAfter,
			snapshotSessionReplaced: snapshotSessionReplaced,
			snapshotTurnsReplaced: snapshotTurnsReplaced,
			storeSessionReplaced: storeSessionReplaced,
			storeTurnsReplaced: storeTurnsReplaced,
			storeSnapshotMatchesRefreshedSnapshot: storeSnapshotMatchesRefreshedSnapshot,
			bufferRebasedAfterRefresh: bufferRebasedAfterRefresh,
			refreshedCwdPreserved: refreshedCwdPreserved,
			resumedTurnsPersisted: resumedTurnsPersisted,
			activeTurnRestoredFromResumedTurns: activeTurnRestoredFromResumedTurns,
			liveOnlyEffectsSuppressed: true,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "refreshed snapshot session persistence mismatch"
		});
	}

	static function countUserMessages(turns:Array<ModelThreadSnapshotSessionRefreshTurn>):Int {
		var count = 0;
		for (turn in turns)
			if (turn.userText.length > 0)
				count = count + 1;
		return count;
	}

	static function latestInProgressTurnId(turns:Array<ModelThreadSnapshotSessionRefreshTurn>):String {
		var active = "";
		for (turn in turns)
			if (turn.statusKind == ModelThreadSnapshotTurnStatusKind.InProgress)
				active = turn.turnId;
		return active;
	}

	static function failure(requestId:String, threadId:String, errorMessage:String):ModelThreadSnapshotSessionRefreshOutcome {
		return new ModelThreadSnapshotSessionRefreshOutcome({
			ok: false,
			code: "thread_snapshot_session_refresh_failed",
			requestId: requestId,
			threadId: threadId,
			decisionKind: ModelThreadSnapshotSessionRefreshDecisionKind.RefreshedSnapshotBlocked,
			snapshotSessionCwdAfter: "",
			storeSessionCwdAfter: "",
			snapshotTurnCountAfter: 0,
			storeTurnCountAfter: 0,
			resumedTurnCount: 0,
			userMessageCount: 0,
			activeTurnIdAfter: "",
			snapshotSessionReplaced: false,
			snapshotTurnsReplaced: false,
			storeSessionReplaced: false,
			storeTurnsReplaced: false,
			storeSnapshotMatchesRefreshedSnapshot: false,
			bufferRebasedAfterRefresh: false,
			refreshedCwdPreserved: false,
			resumedTurnsPersisted: false,
			activeTurnRestoredFromResumedTurns: false,
			liveOnlyEffectsSuppressed: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
