package codexhx.runtime.model.streamitem;

class ModelPendingInteractiveReplayPolicy {
	public static function route(request:ModelPendingInteractiveReplayRequest):ModelPendingInteractiveReplayOutcome {
		if (request == null)
			return failure("", "", ModelPendingInteractiveReplayEventKind.Snapshot, ModelPendingInteractivePromptKind.None,
				"missing pending interactive replay request");
		final reconstructionId = request.reconstructionOutcome == null ? "" : request.reconstructionOutcome.requestId;
		final live = request.reconstructionOutcome != null && request.reconstructionOutcome.liveNetworkAttempted;
		final fs = request.reconstructionOutcome != null && request.reconstructionOutcome.realFilesystemMutated;
		final tool = request.reconstructionOutcome != null && request.reconstructionOutcome.toolExecutedOutsideFixture;
		final promptPresentAfter = promptPresentAfterEvent(request);
		final activeAfter = activeTurnAfter(request);
		final terminal = request.eventKind == ModelPendingInteractiveReplayEventKind.TurnCompleted;

		return new ModelPendingInteractiveReplayOutcome(true, "pending_interactive_replay_modeled", request.requestId, reconstructionId, request.eventKind,
			request.promptKind, request.eventKind == ModelPendingInteractiveReplayEventKind.SetTurns
			&& request.restoredInProgressTurnId.length > 0,
			activeAfter, terminal && request.terminalMatchesActiveTurn, terminal && !request.terminalMatchesActiveTurn && request.activeTurnIdBefore.length > 0,
			request.eventKind == ModelPendingInteractiveReplayEventKind.ServerRequest
			&& request.promptKind != ModelPendingInteractivePromptKind.None, terminal && request.pendingPromptCountForTurnBefore > 0, request.eventKind == ModelPendingInteractiveReplayEventKind.OutboundOp && request.outboundOpCanChangeState && request.outboundOpMatchesPrompt,
			request.eventKind == ModelPendingInteractiveReplayEventKind.ServerRequestResolved
			&& request.requestMatchesPendingPrompt, request.eventKind == ModelPendingInteractiveReplayEventKind.EvictedServerRequest && request.requestMatchesPendingPrompt,
			request.eventKind == ModelPendingInteractiveReplayEventKind.ThreadClosed
			|| request.eventKind == ModelPendingInteractiveReplayEventKind.Rollback, request.snapshotRequested && promptPresentAfter, request.snapshotRequested && !promptPresentAfter && request.promptKind != ModelPendingInteractivePromptKind.None,
			terminal
			&& request.reconstructionOutcome != null
			&& request.reconstructionOutcome.replayTurnCompletedNotificationSynthesized, terminal && request.reconstructionOutcome != null && request.reconstructionOutcome.replayKind == ModelTurnReplayKind.ThreadSnapshot,
			sideStatus(promptPresentAfter, request.promptKind), live, fs, tool, "");
	}

	static function promptPresentAfterEvent(request:ModelPendingInteractiveReplayRequest):Bool {
		return switch request.eventKind {
			case ModelPendingInteractiveReplayEventKind.ServerRequest:
				request.promptKind != ModelPendingInteractivePromptKind.None;
			case ModelPendingInteractiveReplayEventKind.TurnCompleted:
				request.pendingPromptCountBefore > request.pendingPromptCountForTurnBefore;
			case ModelPendingInteractiveReplayEventKind.ServerRequestResolved | ModelPendingInteractiveReplayEventKind.EvictedServerRequest:
				request.pendingPromptCountBefore > 0
				&& !request.requestMatchesPendingPrompt;
			case ModelPendingInteractiveReplayEventKind.OutboundOp: request.pendingPromptCountBefore > 0 && !(request.outboundOpCanChangeState
					&& request.outboundOpMatchesPrompt);
			case ModelPendingInteractiveReplayEventKind.ThreadClosed | ModelPendingInteractiveReplayEventKind.Rollback:
				false;
			case ModelPendingInteractiveReplayEventKind.SetTurns | ModelPendingInteractiveReplayEventKind.Snapshot:
				request.pendingPromptCountBefore > 0;
		}
	}

	static function activeTurnAfter(request:ModelPendingInteractiveReplayRequest):String {
		return switch request.eventKind {
			case ModelPendingInteractiveReplayEventKind.SetTurns:
				request.restoredInProgressTurnId;
			case ModelPendingInteractiveReplayEventKind.TurnCompleted:
				request.terminalMatchesActiveTurn ? "" : request.activeTurnIdBefore;
			case ModelPendingInteractiveReplayEventKind.ThreadClosed | ModelPendingInteractiveReplayEventKind.Rollback:
				"";
			case _:
				request.activeTurnIdBefore;
		}
	}

	static function sideStatus(promptPresentAfter:Bool, promptKind:ModelPendingInteractivePromptKind):ModelPendingInteractiveSideStatusKind {
		if (!promptPresentAfter)
			return ModelPendingInteractiveSideStatusKind.None;
		if (promptKind == ModelPendingInteractivePromptKind.RequestUserInput)
			return ModelPendingInteractiveSideStatusKind.NeedsInput;
		return ModelPendingInteractiveSideStatusKind.NeedsApproval;
	}

	static function failure(requestId:String, reconstructionRequestId:String, eventKind:ModelPendingInteractiveReplayEventKind,
			promptKind:ModelPendingInteractivePromptKind, errorMessage:String):ModelPendingInteractiveReplayOutcome {
		return new ModelPendingInteractiveReplayOutcome(false, "pending_interactive_replay_failed", requestId, reconstructionRequestId, eventKind, promptKind,
			false, "", false, false, false, false, false, false, false, false, false, false, false, false, ModelPendingInteractiveSideStatusKind.None, false,
			false, false, errorMessage);
	}
}
