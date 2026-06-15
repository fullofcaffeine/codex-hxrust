package codexhx.runtime.model.streamitem;

class ModelThreadSnapshotTurnHistoryReplayPolicy {
	public static function replay(request:ModelThreadSnapshotTurnHistoryReplayRequest):ModelThreadSnapshotTurnHistoryReplayOutcome {
		if (request == null) return failure("", ModelTurnReplayKind.ThreadSnapshot, "missing thread snapshot turn history replay request");

		final userMessages:Array<String> = [];
		final agentMessages:Array<String> = [];
		var replayedItemCount = 0;
		var terminalCount = 0;
		var turnOrderPreserved = true;
		var itemOrderPreserved = true;
		var previousTurnOrdinal = -1;

		var turnIndex = 0;
		while (turnIndex < request.turns.length) {
			final turn = request.turns[turnIndex];
			final turnOrdinal = ordinalSuffix(turn.turnId);
			if (turnOrdinal >= 0) {
				if (turnOrdinal < previousTurnOrdinal) turnOrderPreserved = false;
				previousTurnOrdinal = turnOrdinal;
			}

			var itemIndex = 0;
			var seenAgentInTurn = false;
			while (itemIndex < turn.items.length) {
				final item = turn.items[itemIndex];
				switch item.itemKind {
					case ModelThreadSnapshotTurnHistoryItemKind.UserMessage:
						if (seenAgentInTurn) itemOrderPreserved = false;
						userMessages.push(item.text);
						replayedItemCount = replayedItemCount + 1;
					case ModelThreadSnapshotTurnHistoryItemKind.AgentMessage:
						seenAgentInTurn = true;
						agentMessages.push(item.text);
						replayedItemCount = replayedItemCount + 1;
					case ModelThreadSnapshotTurnHistoryItemKind.Other:
						replayedItemCount = replayedItemCount + 1;
				}
				itemIndex = itemIndex + 1;
			}

			if (isTerminal(turn.statusKind)) terminalCount = terminalCount + 1;
			turnIndex = turnIndex + 1;
		}

		final usersMatch = stringArraysEqual(userMessages, request.expectedUserMessages);
		final agentsMatch = stringArraysEqual(agentMessages, request.expectedAgentMessages);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = request.sessionAvailable
			&& request.replayKind == ModelTurnReplayKind.ThreadSnapshot
			&& usersMatch
			&& agentsMatch
			&& turnOrderPreserved
			&& itemOrderPreserved;

		return new ModelThreadSnapshotTurnHistoryReplayOutcome({
			ok: ok,
			code: ok ? "thread_snapshot_turn_history_replay_modeled" : "thread_snapshot_turn_history_replay_blocked",
			requestId: request.requestId,
			replayKind: request.replayKind,
			decisionKind: ok ? ModelThreadSnapshotTurnHistoryDecisionKind.TurnHistoryReplayedInOrder : ModelThreadSnapshotTurnHistoryDecisionKind.TurnHistoryReplayBlocked,
			turnCount: request.turns.length,
			replayedItemCount: replayedItemCount,
			userMessageCount: userMessages.length,
			agentMessageCount: agentMessages.length,
			terminalTurnCompletedNotificationCount: terminalCount,
			transcriptUserMessages: userMessages,
			transcriptAgentMessages: agentMessages,
			userMessagesInExpectedOrder: usersMatch,
			agentMessagesInExpectedOrder: agentsMatch,
			turnOrderPreserved: turnOrderPreserved,
			itemOrderPreserved: itemOrderPreserved,
			sessionAppliedBeforeTurns: request.sessionAvailable,
			queueAutosendSuppressed: !request.resumeRestoredQueue,
			liveOnlyEffectsSuppressed: true,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "turn history replay ordering mismatch"
		});
	}

	static function isTerminal(status:ModelThreadSnapshotTurnStatusKind):Bool {
		return status == ModelThreadSnapshotTurnStatusKind.Completed
			|| status == ModelThreadSnapshotTurnStatusKind.Failed
			|| status == ModelThreadSnapshotTurnStatusKind.Interrupted;
	}

	static function stringArraysEqual(actual:Array<String>, expected:Array<String>):Bool {
		if (actual.length != expected.length) return false;
		var i = 0;
		while (i < actual.length) {
			if (actual[i] != expected[i]) return false;
			i = i + 1;
		}
		return true;
	}

	static function ordinalSuffix(value:String):Int {
		if (value == null || value.length == 0) return -1;
		var i = value.length - 1;
		while (i >= 0) {
			final code = value.charCodeAt(i);
			if (code < 48 || code > 57) break;
			i = i - 1;
		}
		if (i == value.length - 1) return -1;
		return Std.parseInt(value.substr(i + 1));
	}

	static function failure(
		requestId:String,
		replayKind:ModelTurnReplayKind,
		errorMessage:String
	):ModelThreadSnapshotTurnHistoryReplayOutcome {
		return new ModelThreadSnapshotTurnHistoryReplayOutcome({
			ok: false,
			code: "thread_snapshot_turn_history_replay_failed",
			requestId: requestId,
			replayKind: replayKind,
			decisionKind: ModelThreadSnapshotTurnHistoryDecisionKind.TurnHistoryReplayBlocked,
			turnCount: 0,
			replayedItemCount: 0,
			userMessageCount: 0,
			agentMessageCount: 0,
			terminalTurnCompletedNotificationCount: 0,
			transcriptUserMessages: [],
			transcriptAgentMessages: [],
			userMessagesInExpectedOrder: false,
			agentMessagesInExpectedOrder: false,
			turnOrderPreserved: false,
			itemOrderPreserved: false,
			sessionAppliedBeforeTurns: false,
			queueAutosendSuppressed: false,
			liveOnlyEffectsSuppressed: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
