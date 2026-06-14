package codexhx.runtime.model.streamitem;

class ModelSamplingContinuationPolicy {
	public static function plan(request:ModelSamplingContinuationRequest):ModelSamplingContinuationOutcome {
		if (request == null) return failure("", "missing sampling continuation request");
		if (request.responseInputOutcome == null || !request.responseInputOutcome.ok) {
			return failure(request.requestId, "sampling continuation requires an admitted response input outcome");
		}

		final modelNeedsFollowUp = request.responseInputOutcome.followUpRequestRequired;
		final hasPendingInput = request.hasPendingInput && request.pendingInputCount > 0;
		final needsFollowUp = modelNeedsFollowUp || hasPendingInput;
		final autoCompactRequired = request.tokenLimitReached && needsFollowUp;
		final canDrainPendingInputBeforeNextRequest = !autoCompactRequired || !modelNeedsFollowUp;
		final pendingInputDrained = hasPendingInput && canDrainPendingInputBeforeNextRequest;
		final admittedResponseInputCount = request.responseInputOutcome.admissionKind == ModelPatchToolResponseAdmissionKind.Admitted
			? request.responseInputOutcome.nextInputCount
			: 0;
		final responseInputCarried = admittedResponseInputCount > 0
			&& request.responseInputOutcome.toolFutureDrained
			&& request.responseInputOutcome.conversationItemRecorded;
		final nextSamplingInputCount = admittedResponseInputCount + (pendingInputDrained ? request.pendingInputCount : 0);
		final nextSamplingRequestIndex = needsFollowUp ? request.previousSamplingRequestCount + 1 : request.previousSamplingRequestCount;

		return new ModelSamplingContinuationOutcome(
			true,
			"sampling_continuation_planned",
			request.requestId,
			continuationKind(modelNeedsFollowUp, hasPendingInput, autoCompactRequired),
			modelNeedsFollowUp,
			hasPendingInput,
			needsFollowUp,
			needsFollowUp,
			responseInputCarried,
			pendingInputDrained,
			autoCompactRequired,
			canDrainPendingInputBeforeNextRequest,
			admittedResponseInputCount,
			request.pendingInputCount,
			nextSamplingInputCount,
			nextSamplingRequestIndex,
			request.activeContextTokens,
			request.estimatedTokenCount,
			false,
			false,
			false,
			""
		);
	}

	static function continuationKind(
		modelNeedsFollowUp:Bool,
		hasPendingInput:Bool,
		autoCompactRequired:Bool
	):ModelSamplingContinuationKind {
		if (autoCompactRequired) return ModelSamplingContinuationKind.TokenLimitCompaction;
		if (modelNeedsFollowUp && hasPendingInput) return ModelSamplingContinuationKind.ModelFollowUpAndPendingInput;
		if (modelNeedsFollowUp) return ModelSamplingContinuationKind.ModelFollowUp;
		if (hasPendingInput) return ModelSamplingContinuationKind.PendingInput;
		return ModelSamplingContinuationKind.None;
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingContinuationOutcome {
		return new ModelSamplingContinuationOutcome(
			false,
			"sampling_continuation_failed",
			requestId,
			ModelSamplingContinuationKind.None,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			0,
			0,
			0,
			0,
			0,
			0,
			false,
			false,
			false,
			errorMessage
		);
	}
}
