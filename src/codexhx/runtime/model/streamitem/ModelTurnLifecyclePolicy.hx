package codexhx.runtime.model.streamitem;

class ModelTurnLifecyclePolicy {
	public static function finish(request:ModelTurnLifecycleRequest):ModelTurnLifecycleOutcome {
		if (request == null)
			return failure("", "", "missing turn lifecycle request");
		final stopHookId = request.terminalStopHookOutcome == null ? "" : request.terminalStopHookOutcome.requestId;
		final errorId = request.samplingErrorTerminalOutcome == null ? "" : request.samplingErrorTerminalOutcome.requestId;
		final live = (request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.liveNetworkAttempted)
			|| (request.samplingErrorTerminalOutcome != null && request.samplingErrorTerminalOutcome.liveNetworkAttempted);
		final fs = (request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.realFilesystemMutated)
			|| (request.samplingErrorTerminalOutcome != null && request.samplingErrorTerminalOutcome.realFilesystemMutated);
		final tool = (request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.toolExecutedOutsideFixture)
			|| (request.samplingErrorTerminalOutcome != null && request.samplingErrorTerminalOutcome.toolExecutedOutsideFixture);

		if (request.taskCancellationRequested) {
			return new ModelTurnLifecycleOutcome(true, "turn_lifecycle_modeled", request.requestId, request.turnId, request.terminalKind,
				ModelTurnLifecycleEventKind.CompletionSuppressedForCancellation, stopHookId, errorId, request.rolloutFlushOk, !request.rolloutFlushOk, false,
				false, request.samplingErrorTerminalOutcome != null
				&& request.samplingErrorTerminalOutcome.lifecycleErrorEmitted, false, false, true,
				request.terminalKind == ModelTurnLifecycleTerminalKind.CompletedAfterError, false, false, "", false, false, live, fs, tool,
				"turn completion suppressed because task cancellation was requested");
		}

		return switch request.terminalKind {
			case ModelTurnLifecycleTerminalKind.Aborted:
				abort(request, stopHookId, errorId, live, fs, tool);
			case ModelTurnLifecycleTerminalKind.CompletedAfterError:
				complete(request, stopHookId, errorId, true, live, fs, tool);
			case ModelTurnLifecycleTerminalKind.Completed:
				complete(request, stopHookId, errorId, false, live, fs, tool);
		}
	}

	static function complete(request:ModelTurnLifecycleRequest, stopHookId:String, errorId:String, completedAfterError:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool):ModelTurnLifecycleOutcome {
		final message = request.lastAgentMessage.length > 0 ? request.lastAgentMessage : inheritedLastAgentMessage(request);
		final activeCleared = request.activeTurnMatches;
		return new ModelTurnLifecycleOutcome(true, "turn_lifecycle_modeled", request.requestId, request.turnId, request.terminalKind,
			ModelTurnLifecycleEventKind.TurnComplete, stopHookId, errorId, request.rolloutFlushOk, !request.rolloutFlushOk, true,
			false, request.samplingErrorTerminalOutcome != null && request.samplingErrorTerminalOutcome.lifecycleErrorEmitted, true, false, false,
			completedAfterError, false, message.length > 0, message, activeCleared, activeCleared && !request.hasPendingTriggerMailbox, liveNetworkAttempted,
			realFilesystemMutated, toolExecutedOutsideFixture, "");
	}

	static function abort(request:ModelTurnLifecycleRequest, stopHookId:String, errorId:String, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool):ModelTurnLifecycleOutcome {
		final reason = request.abortReason.length == 0 ? "unknown" : request.abortReason;
		return new ModelTurnLifecycleOutcome(true, "turn_lifecycle_modeled", request.requestId, request.turnId, ModelTurnLifecycleTerminalKind.Aborted,
			ModelTurnLifecycleEventKind.TurnAborted, stopHookId, errorId, request.rolloutFlushOk, !request.rolloutFlushOk, false, true, false, false, true,
			false, false, request.interruptedMarkerEligible && reason == "interrupted", false, "", true, !request.hasPendingTriggerMailbox,
			liveNetworkAttempted, realFilesystemMutated, toolExecutedOutsideFixture, reason);
	}

	static function inheritedLastAgentMessage(request:ModelTurnLifecycleRequest):String {
		if (request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.lastAgentMessage.length > 0) {
			return request.terminalStopHookOutcome.lastAgentMessage;
		}
		if (request.samplingErrorTerminalOutcome != null && request.samplingErrorTerminalOutcome.lastAgentMessage.length > 0) {
			return request.samplingErrorTerminalOutcome.lastAgentMessage;
		}
		return "";
	}

	static function failure(requestId:String, turnId:String, errorMessage:String):ModelTurnLifecycleOutcome {
		return new ModelTurnLifecycleOutcome(false, "turn_lifecycle_failed", requestId, turnId, ModelTurnLifecycleTerminalKind.Completed,
			ModelTurnLifecycleEventKind.TurnComplete, "", "", false, false, false, false, false, false, false, false, false, false, false, "", false, false,
			false, false, false, errorMessage);
	}
}
