package codexhx.runtime.model.streamitem;

class ModelSamplingStreamAttemptPolicy {
	public static function evaluate(request:ModelSamplingStreamAttemptRequest):ModelSamplingStreamAttemptOutcome {
		if (request == null)
			return failure("", "missing sampling stream attempt request");
		if (request.dispatchOutcome == null || !request.dispatchOutcome.ok) {
			return failure(request.requestId, "sampling stream attempt requires dispatch outcome");
		}

		final retryable = request.errorKind == ModelSamplingStreamErrorKind.StreamDisconnected;
		final retryScheduled = retryable && request.currentRetryCount < request.dispatchOutcome.maxRetries;
		final unauthorized = request.errorKind == ModelSamplingStreamErrorKind.Unauthorized;
		final contextWindow = request.errorKind == ModelSamplingStreamErrorKind.ContextWindowExceeded;
		final usageLimit = request.errorKind == ModelSamplingStreamErrorKind.UsageLimitReached;
		final streamOpened = request.errorKind == ModelSamplingStreamErrorKind.None;
		final unauthorizedPrepared = unauthorized && request.unauthorizedRecoveryAvailable;
		final terminal = contextWindow
			|| usageLimit
			|| request.errorKind == ModelSamplingStreamErrorKind.NonRetryableApiError
			|| (retryable && !retryScheduled)
			|| (unauthorized && !unauthorizedPrepared);
		final resultKind = if (streamOpened) {
			ModelSamplingStreamAttemptResultKind.FixtureStreamOpened;
		} else if (retryScheduled) {
			ModelSamplingStreamAttemptResultKind.RetryScheduled;
		} else if (unauthorizedPrepared) {
			ModelSamplingStreamAttemptResultKind.UnauthorizedRetryPrepared;
		} else {
			ModelSamplingStreamAttemptResultKind.TerminalError;
		};

		return new ModelSamplingStreamAttemptOutcome(true, "sampling_stream_attempt_evaluated", request.requestId, resultKind, request.errorKind, retryable,
			retryScheduled, request.currentRetryCount, retryScheduled ? request.currentRetryCount + 1 : request.currentRetryCount,
			request.dispatchOutcome.maxRetries, unauthorizedPrepared, contextWindow, usageLimit && request.rateLimitUpdated, terminal, streamOpened,
			request.dispatchOutcome.dispatchAttemptIndex, request.dispatchOutcome.promptItemCount, request.dispatchOutcome.liveProviderRequestAttempted,
			streamOpened
			&& request.dispatchOutcome.providerStreamOpened, false, false, false, "");
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingStreamAttemptOutcome {
		return new ModelSamplingStreamAttemptOutcome(false, "sampling_stream_attempt_failed", requestId, ModelSamplingStreamAttemptResultKind.TerminalError,
			ModelSamplingStreamErrorKind.NonRetryableApiError, false, false, 0, 0, 0, false, false, false, true, false, 0, 0, false, false, false, false,
			false, errorMessage);
	}
}
