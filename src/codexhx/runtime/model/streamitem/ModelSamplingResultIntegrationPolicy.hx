package codexhx.runtime.model.streamitem;

class ModelSamplingResultIntegrationPolicy {
	public static function integrate(request:ModelSamplingResultIntegrationRequest):ModelSamplingResultIntegrationOutcome {
		if (request == null) return failure("", "missing sampling result integration request");
		final postDrain = request.postDrainEmissionOutcome;
		if (postDrain == null || !postDrain.ok) return failure(request.requestId, "sampling result integration requires a post-drain outcome");

		final cancellation = request.statusKind == ModelSamplingResultIntegrationStatusKind.Cancelled || !postDrain.samplingOutcomeReturned;
		final error = request.statusKind == ModelSamplingResultIntegrationStatusKind.Error;
		if (cancellation) return bypass(request, ModelSamplingResultIntegrationDecisionKind.BypassCancellation, true, false);
		if (error) return bypass(request, ModelSamplingResultIntegrationDecisionKind.BypassError, false, true);

		final hasPendingInput = request.hasPendingInput && request.pendingInputCount > 0;
		final needsFollowUp = request.modelNeedsFollowUp || hasPendingInput;
		final autoCompact = request.tokenLimitReached && needsFollowUp;
		final stopTurn = !needsFollowUp;
		final decisionKind = autoCompact
			? ModelSamplingResultIntegrationDecisionKind.AutoCompact
			: (stopTurn ? ModelSamplingResultIntegrationDecisionKind.StopTurn : ModelSamplingResultIntegrationDecisionKind.ContinueSampling);
		final lastAgentMessageUpdated = stopTurn && request.lastAgentMessage.length > 0;
		final canDrainAfterAutoCompact = autoCompact && !request.modelNeedsFollowUp;

		return new ModelSamplingResultIntegrationOutcome(
			true,
			"sampling_result_integrated",
			request.requestId,
			decisionKind,
			ModelSamplingResultIntegrationStatusKind.Ok,
			request.modelNeedsFollowUp,
			hasPendingInput,
			needsFollowUp,
			true,
			canDrainAfterAutoCompact,
			request.tokenLimitReached,
			lastAgentMessageUpdated,
			lastAgentMessageUpdated ? request.lastAgentMessage : request.previousLastAgentMessage,
			request.previousLastAgentMessage,
			true,
			stopTurn,
			!stopTurn,
			stopTurn,
			false,
			false,
			postDrain.liveNetworkAttempted,
			postDrain.realFilesystemMutated,
			postDrain.toolExecutedOutsideFixture,
			""
		);
	}

	static function bypass(
		request:ModelSamplingResultIntegrationRequest,
		decisionKind:ModelSamplingResultIntegrationDecisionKind,
		cancelled:Bool,
		error:Bool
	):ModelSamplingResultIntegrationOutcome {
		final postDrain = request.postDrainEmissionOutcome;
		return new ModelSamplingResultIntegrationOutcome(
			true,
			"sampling_result_integrated",
			request.requestId,
			decisionKind,
			request.statusKind,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			request.previousLastAgentMessage,
			request.previousLastAgentMessage,
			false,
			false,
			false,
			true,
			cancelled,
			error,
			postDrain.liveNetworkAttempted,
			postDrain.realFilesystemMutated,
			postDrain.toolExecutedOutsideFixture,
			cancelled ? "sampling result bypassed by cancellation" : "sampling result bypassed by error"
		);
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingResultIntegrationOutcome {
		return new ModelSamplingResultIntegrationOutcome(
			false,
			"sampling_result_integration_failed",
			requestId,
			ModelSamplingResultIntegrationDecisionKind.BypassError,
			ModelSamplingResultIntegrationStatusKind.Error,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			"",
			"",
			false,
			false,
			false,
			true,
			false,
			true,
			false,
			false,
			false,
			errorMessage
		);
	}
}
