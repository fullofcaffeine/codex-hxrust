package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadComposerHandoffPolicy {
	public static function apply(request:ModelThreadSideThreadComposerHandoffRequest):ModelThreadSideThreadComposerHandoffOutcome {
		if (request == null)
			return failure("", "", "", "missing thread side-thread composer handoff request");
		final startRequestId = request.startOutcome == null ? "" : request.startOutcome.requestId;
		final startupRoutingRequestId = request.startupRoutingOutcome == null ? "" : request.startupRoutingOutcome.requestId;
		if (request.startOutcome == null)
			return failure(request.requestId, "", startupRoutingRequestId, "missing thread side-thread start outcome");
		if (!request.startOutcome.ok)
			return failure(request.requestId, startRequestId, startupRoutingRequestId, "thread side-thread start outcome was not successful");
		if (request.startupRoutingOutcome != null && !request.startupRoutingOutcome.ok) {
			return failure(request.requestId, startRequestId, startupRoutingRequestId, "thread side-thread startup routing outcome was not successful");
		}

		final hasMessage = request.userMessageProvided;
		if (!hasMessage) {
			return success(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.NoUserMessageNoop, false, false,
				false, "", false);
		}

		return switch request.startOutcome.decisionKind {
			case StartBlockedMainUnavailable | StartBlockedSideOpen:
				restored(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterStartBlocked);
			case ForkFailedNoStartedConversation | ForkFailedGeneric:
				restored(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterForkFailure);
			case InjectFailedCleanup:
				restored(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterPrepareFailure);
			case SwitchFailedCleanup:
				restored(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterSwitchFailure);
			case SwitchedInactiveCleanup:
				restored(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterInactiveChildCleanup);
			case SwitchedAndSubmittedUserMessage:
				success(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.SubmittedAfterSwitch, true, false,
					false, "", true);
			case SwitchedWithoutUserMessage:
				success(request, startRequestId, startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.NoUserMessageNoop, false, false,
					false, "", false);
		}
	}

	static function restored(request:ModelThreadSideThreadComposerHandoffRequest, startRequestId:String, startupRoutingRequestId:String,
			decisionKind:ModelThreadSideThreadComposerHandoffDecisionKind):ModelThreadSideThreadComposerHandoffOutcome {
		return success(request, startRequestId, startupRoutingRequestId, decisionKind, true, true, true, request.inlineUserMessageText, false);
	}

	static function success(request:ModelThreadSideThreadComposerHandoffRequest, startRequestId:String, startupRoutingRequestId:String,
			decisionKind:ModelThreadSideThreadComposerHandoffDecisionKind, userMessagePreserved:Bool, restoreAttempted:Bool, composerMutated:Bool,
			composerTextAfter:String, submittedAsPlainUserTurn:Bool):ModelThreadSideThreadComposerHandoffOutcome {
		final startupRoutingComposed = request.startupRoutingOutcome != null;
		final sourceOrderingPreserved = startupRoutingComposed ? request.startupRoutingOutcome.eventOrderingPreserved : request.startOutcome.eventOrderingPreserved;
		final liveNetworkAttempted = startupRoutingComposed ? request.startupRoutingOutcome.liveNetworkAttempted : request.startOutcome.liveNetworkAttempted;
		final realFilesystemMutated = startupRoutingComposed ? request.startupRoutingOutcome.realFilesystemMutated : request.startOutcome.realFilesystemMutated;
		final toolExecutedOutsideFixture = startupRoutingComposed ? request.startupRoutingOutcome.toolExecutedOutsideFixture : request.startOutcome.toolExecutedOutsideFixture;
		return new ModelThreadSideThreadComposerHandoffOutcome(true, "thread_side_thread_composer_handoff_modeled", request.requestId, startRequestId,
			startupRoutingRequestId, decisionKind, userMessagePreserved, restoreAttempted, composerMutated, composerTextAfter, submittedAsPlainUserTurn,
			request.userMessageProvided
			&& (restoreAttempted != submittedAsPlainUserTurn), request.startOutcome.sideUiSynced,
			request.startOutcome.contextLabelCleared, request.startOutcome.errorMessageAdded, request.startOutcome.runControlContinue, startupRoutingComposed,
			sourceOrderingPreserved
			&& request.eventOrderIndex == request.previousEventCount + 1, liveNetworkAttempted, realFilesystemMutated,
			toolExecutedOutsideFixture, "");
	}

	static function failure(requestId:String, startRequestId:String, startupRoutingRequestId:String,
			errorMessage:String):ModelThreadSideThreadComposerHandoffOutcome {
		return new ModelThreadSideThreadComposerHandoffOutcome(false, "thread_side_thread_composer_handoff_failed", requestId, startRequestId,
			startupRoutingRequestId, ModelThreadSideThreadComposerHandoffDecisionKind.NoUserMessageNoop, false, false, false, "", false, false, false, false,
			false, false, startupRoutingRequestId.length > 0, false, false, false, false, errorMessage);
	}
}
