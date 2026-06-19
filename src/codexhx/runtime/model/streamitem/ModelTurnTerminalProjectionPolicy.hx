package codexhx.runtime.model.streamitem;

class ModelTurnTerminalProjectionPolicy {
	public static function project(request:ModelTurnTerminalProjectionRequest):ModelTurnTerminalProjectionOutcome {
		if (request == null)
			return failure("", "", "", "", ModelTurnTerminalProjectionEventKind.TurnComplete, "missing turn terminal projection request");
		if (request.lifecycleOutcome == null) {
			return failure(request.requestId, request.threadId, request.turnId, "", request.eventKind, "missing turn lifecycle outcome");
		}
		if (!request.lifecycleOutcome.ok) {
			return failure(request.requestId, request.threadId, request.turnId, request.lifecycleOutcome.requestId, request.eventKind,
				"turn lifecycle outcome was not successful");
		}

		return switch request.eventKind {
			case ModelTurnTerminalProjectionEventKind.TurnComplete:
				projectComplete(request);
			case ModelTurnTerminalProjectionEventKind.TurnAborted:
				projectAborted(request);
		}
	}

	static function projectComplete(request:ModelTurnTerminalProjectionRequest):ModelTurnTerminalProjectionOutcome {
		if (!request.lifecycleOutcome.turnCompleteEmitted) {
			return failure(request.requestId, request.threadId, request.turnId, request.lifecycleOutcome.requestId, request.eventKind,
				"lifecycle did not emit TurnComplete");
		}
		final priorError = hasPriorTurnError(request);
		final message = lastAgentMessage(request);
		final notifyUser = !request.fromReplay && !request.hasQueuedFollowUp && !request.activeGoalContinuing;
		return new ModelTurnTerminalProjectionOutcome(true, "turn_terminal_projection_modeled", request.requestId, request.threadId, projectedTurnId(request),
			request.lifecycleOutcome.requestId, ModelTurnTerminalProjectionEventKind.TurnComplete, ModelTurnTerminalProjectedStatusKind.Completed,
			priorError ? ModelTurnTerminalProjectedStatusKind.Failed : ModelTurnTerminalProjectedStatusKind.Completed,
			ModelTurnTerminalNotificationIntentKind.AppServerTurnCompleted,
			priorError ? ModelTurnTerminalNotificationIntentKind.TuiErrorSurface : (notifyUser ? ModelTurnTerminalNotificationIntentKind.TuiAgentTurnComplete : ModelTurnTerminalNotificationIntentKind.None),
			true, true, true, true, priorError, true, priorError, message.length > 0, message.length > 0,
			false, !priorError && notifyUser && request.sawCopySourceThisTurn, !priorError, false, priorError, request.lifecycleOutcome.liveNetworkAttempted,
			request.lifecycleOutcome.realFilesystemMutated, request.lifecycleOutcome.toolExecutedOutsideFixture, priorError ? turnErrorMessage(request) : "");
	}

	static function projectAborted(request:ModelTurnTerminalProjectionRequest):ModelTurnTerminalProjectionOutcome {
		if (!request.lifecycleOutcome.turnAbortedEmitted) {
			return failure(request.requestId, request.threadId, request.turnId, request.lifecycleOutcome.requestId, request.eventKind,
				"lifecycle did not emit TurnAborted");
		}
		final reason = abortReason(request);
		final coreStatus = isInterruptedReason(reason) ? ModelTurnTerminalProjectedStatusKind.Interrupted : ModelTurnTerminalProjectedStatusKind.Errored;
		return new ModelTurnTerminalProjectionOutcome(true, "turn_terminal_projection_modeled", request.requestId, request.threadId, projectedTurnId(request),
			request.lifecycleOutcome.requestId, ModelTurnTerminalProjectionEventKind.TurnAborted, coreStatus,
			ModelTurnTerminalProjectedStatusKind.Interrupted, ModelTurnTerminalNotificationIntentKind.AppServerTurnCompleted,
			ModelTurnTerminalNotificationIntentKind.TuiInterruptedTurn, true, request.pendingInterruptRequest, true, false, false, true, false, false, false,
			false, false, false, true, false, request.lifecycleOutcome.liveNetworkAttempted, request.lifecycleOutcome.realFilesystemMutated,
			request.lifecycleOutcome.toolExecutedOutsideFixture, reason);
	}

	static function hasPriorTurnError(request:ModelTurnTerminalProjectionRequest):Bool {
		return request.priorTurnErrorMessage.length > 0
			|| request.lifecycleOutcome.completedAfterError
			|| request.lifecycleOutcome.turnErrorLifecycleAlreadyEmitted;
	}

	static function lastAgentMessage(request:ModelTurnTerminalProjectionRequest):String {
		if (request.lastAgentMessageOverride.length > 0)
			return request.lastAgentMessageOverride;
		return request.lifecycleOutcome.lastAgentMessage;
	}

	static function turnErrorMessage(request:ModelTurnTerminalProjectionRequest):String {
		if (request.priorTurnErrorMessage.length > 0)
			return request.priorTurnErrorMessage;
		return "turn completed after a previously recorded error";
	}

	static function abortReason(request:ModelTurnTerminalProjectionRequest):String {
		if (request.abortReason.length > 0)
			return request.abortReason;
		if (request.lifecycleOutcome.errorMessage.length > 0)
			return request.lifecycleOutcome.errorMessage;
		return "unknown";
	}

	static function isInterruptedReason(reason:String):Bool {
		return reason == "interrupted" || reason == "budget_limited";
	}

	static function projectedTurnId(request:ModelTurnTerminalProjectionRequest):String {
		return request.turnId.length > 0 ? request.turnId : request.lifecycleOutcome.turnId;
	}

	static function failure(requestId:String, threadId:String, turnId:String, lifecycleRequestId:String, eventKind:ModelTurnTerminalProjectionEventKind,
			errorMessage:String):ModelTurnTerminalProjectionOutcome {
		return new ModelTurnTerminalProjectionOutcome(false, "turn_terminal_projection_failed", requestId, threadId, turnId, lifecycleRequestId, eventKind,
			ModelTurnTerminalProjectedStatusKind.Errored, ModelTurnTerminalProjectedStatusKind.Failed, ModelTurnTerminalNotificationIntentKind.None,
			ModelTurnTerminalNotificationIntentKind.None, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, errorMessage);
	}
}
