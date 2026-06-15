package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadStartPolicy {
	public static function apply(request:ModelThreadSideThreadStartRequest):ModelThreadSideThreadStartOutcome {
		if (request == null) return failure("", "", "missing thread side-thread start request");
		final cleanupRequestId = request.cleanupOutcome == null ? "" : request.cleanupOutcome.requestId;
		if (request.cleanupOutcome == null) return failure(request.requestId, "", "missing thread side-thread cleanup outcome");
		if (!request.cleanupOutcome.ok) return failure(request.requestId, cleanupRequestId, "thread side-thread cleanup outcome was not successful");

		if (!request.primaryThreadAvailable) {
			return success(
				request,
				cleanupRequestId,
				ModelThreadSideThreadStartDecisionKind.StartBlockedMainUnavailable,
				ModelThreadSideThreadStartFailureKind.MainThreadUnavailable,
				true,
				request.userMessageProvided,
				true,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				true,
				"'/side' is unavailable until the main thread is ready."
			);
		}

		if (request.sideThreadAlreadyOpen) {
			return success(
				request,
				cleanupRequestId,
				ModelThreadSideThreadStartDecisionKind.StartBlockedSideOpen,
				ModelThreadSideThreadStartFailureKind.SideAlreadyOpen,
				true,
				request.userMessageProvided,
				true,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				true,
				"A side conversation is already open. Press Ctrl+C to return before starting another."
			);
		}

		final parentModelApplied = trim(request.parentModel).length > 0;
		final inheritedRuntimeSettings = trim(request.parentReasoningEffort).length > 0
			|| trim(request.parentServiceTier).length > 0
			|| trim(request.parentApprovalPolicy).length > 0
			|| trim(request.parentPermissionProfile).length > 0
			|| trim(request.parentApprovalsReviewer).length > 0;
		final developerInstructionsAppended = trim(request.existingDeveloperInstructions).length > 0;

		if (!request.forkSucceeded) {
			final noStarted = isNoStartedConversationError(request.forkErrorMessage);
			return success(
				request,
				cleanupRequestId,
				noStarted
					? ModelThreadSideThreadStartDecisionKind.ForkFailedNoStartedConversation
					: ModelThreadSideThreadStartDecisionKind.ForkFailedGeneric,
				noStarted
					? ModelThreadSideThreadStartFailureKind.ForkNoStartedConversation
					: ModelThreadSideThreadStartFailureKind.ForkGeneric,
				false,
				request.userMessageProvided,
				false,
				true,
				true,
				true,
				true,
				true,
				parentModelApplied,
				inheritedRuntimeSettings,
				developerInstructionsAppended,
				true,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				true,
				noStarted
					? "'/side' is unavailable until the current conversation has started. Send a message first, then try /side again."
					: "Failed to start side conversation: " + request.forkErrorMessage
			);
		}

		if (!request.injectBoundarySucceeded) {
			return success(
				request,
				cleanupRequestId,
				ModelThreadSideThreadStartDecisionKind.InjectFailedCleanup,
				ModelThreadSideThreadStartFailureKind.InjectBoundary,
				false,
				request.userMessageProvided,
				false,
				false,
				true,
				true,
				true,
				true,
				parentModelApplied,
				inheritedRuntimeSettings,
				developerInstructionsAppended,
				true,
				true,
				false,
				true,
				true,
				true,
				false,
				true,
				true,
				"Failed to prepare side conversation"
			);
		}

		if (!request.switchSucceeded) {
			return success(
				request,
				cleanupRequestId,
				ModelThreadSideThreadStartDecisionKind.SwitchFailedCleanup,
				ModelThreadSideThreadStartFailureKind.SwitchFailed,
				false,
				request.userMessageProvided,
				false,
				false,
				true,
				true,
				true,
				true,
				parentModelApplied,
				inheritedRuntimeSettings,
				developerInstructionsAppended,
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				request.discardCleanupSucceeded,
				true,
				"Failed to switch into side conversation"
			);
		}

		if (!request.activeChildAfterSwitch) {
			return success(
				request,
				cleanupRequestId,
				ModelThreadSideThreadStartDecisionKind.SwitchedInactiveCleanup,
				ModelThreadSideThreadStartFailureKind.ActiveChildMissing,
				false,
				request.userMessageProvided,
				false,
				false,
				true,
				true,
				true,
				true,
				parentModelApplied,
				inheritedRuntimeSettings,
				developerInstructionsAppended,
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				"Failed to switch into side conversation."
			);
		}

		return success(
			request,
			cleanupRequestId,
			request.userMessageProvided
				? ModelThreadSideThreadStartDecisionKind.SwitchedAndSubmittedUserMessage
				: ModelThreadSideThreadStartDecisionKind.SwitchedWithoutUserMessage,
			ModelThreadSideThreadStartFailureKind.None,
			false,
			false,
			false,
			false,
			true,
			true,
			true,
			true,
			parentModelApplied,
			inheritedRuntimeSettings,
			developerInstructionsAppended,
			true,
			true,
			true,
			true,
			true,
			true,
			true,
			false,
			false,
			""
			);
		}

	static function success(
		request:ModelThreadSideThreadStartRequest,
		cleanupRequestId:String,
		decisionKind:ModelThreadSideThreadStartDecisionKind,
		failureKind:ModelThreadSideThreadStartFailureKind,
		startBlocked:Bool,
		userMessageRestored:Bool,
		sideUiSynced:Bool,
		contextLabelCleared:Bool,
		telemetryRecorded:Bool,
		configRefreshAttempted:Bool,
		forkAttempted:Bool,
		forkConfigEphemeral:Bool,
		parentModelApplied:Bool,
		inheritedRuntimeSettings:Bool,
		developerInstructionsAppended:Bool,
		developerGuardrailsApplied:Bool,
		boundaryPromptItemBuilt:Bool,
		boundaryPromptInjected:Bool,
		snapshotInstalled:Bool,
		forkedParentTranscriptHidden:Bool,
		sideThreadRegistered:Bool,
		switchAttempted:Bool,
		discardCleanupAttempted:Bool,
		errorMessageAdded:Bool,
		errorMessage:String
	):ModelThreadSideThreadStartOutcome {
		return new ModelThreadSideThreadStartOutcome(
			true,
			"thread_side_thread_start_modeled",
			request.requestId,
			cleanupRequestId,
			decisionKind,
			failureKind,
			startBlocked,
			userMessageRestored,
			sideUiSynced,
			contextLabelCleared,
			telemetryRecorded,
			configRefreshAttempted,
			forkAttempted,
			forkConfigEphemeral,
			parentModelApplied,
			inheritedRuntimeSettings,
			developerInstructionsAppended,
			developerGuardrailsApplied,
			boundaryPromptItemBuilt,
			boundaryPromptInjected,
			snapshotInstalled,
			forkedParentTranscriptHidden,
			sideThreadRegistered,
			switchAttempted,
			discardCleanupAttempted,
			discardCleanupAttempted && request.discardCleanupSucceeded && !request.activeThreadRestoredToParent,
			request.userMessageProvided && switchAttempted && !discardCleanupAttempted && failureKind == ModelThreadSideThreadStartFailureKind.None,
			errorMessageAdded,
			true,
			request.cleanupOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.cleanupOutcome.liveNetworkAttempted,
			request.cleanupOutcome.realFilesystemMutated,
			request.cleanupOutcome.toolExecutedOutsideFixture,
			errorMessage
		);
	}

	static function failure(requestId:String, cleanupRequestId:String, errorMessage:String):ModelThreadSideThreadStartOutcome {
		return new ModelThreadSideThreadStartOutcome(
			false,
			"thread_side_thread_start_failed",
			requestId,
			cleanupRequestId,
			ModelThreadSideThreadStartDecisionKind.StartBlockedMainUnavailable,
			ModelThreadSideThreadStartFailureKind.MainThreadUnavailable,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			true,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}

	static function isNoStartedConversationError(message:String):Bool {
		return contains(message, "no rollout found for thread id")
			|| contains(message, "includeTurns is unavailable before first user message");
	}

	static function contains(value:String, needle:String):Bool {
		return value != null && value.indexOf(needle) >= 0;
	}

	static function trim(value:String):String {
		return value == null ? "" : StringTools.trim(value);
	}
}
