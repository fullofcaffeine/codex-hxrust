package codexhx.runtime.model.streamitem;

class ModelSamplingStreamEventHandoffPolicy {
	public static function model(request:ModelSamplingStreamEventHandoffRequest):ModelSamplingStreamEventHandoffOutcome {
		if (request == null)
			return failure("", "missing sampling stream event handoff request");
		final attempt = request.attemptOutcome;
		if (attempt == null || !attempt.ok)
			return failure(request.requestId, "stream event handoff requires a valid attempt outcome");

		if (attempt.retryScheduled) {
			return outcome(request, ModelSamplingStreamHandoffKind.ScheduleRetry, ModelSamplingStreamEventClassKind.AttemptRetry, false, false, false, false,
				false, "");
		}
		if (attempt.unauthorizedRetryStatePrepared) {
			return outcome(request, ModelSamplingStreamHandoffKind.PrepareUnauthorizedRetry, ModelSamplingStreamEventClassKind.AttemptRetry, false, false,
				false, false, false, "");
		}
		if (attempt.terminal) {
			return outcome(request, ModelSamplingStreamHandoffKind.TerminalError, ModelSamplingStreamEventClassKind.AttemptTerminal, true, false, false,
				false, false, "stream attempt ended before event consumption");
		}
		if (!attempt.streamOpened) {
			return outcome(request, ModelSamplingStreamHandoffKind.TerminalError, ModelSamplingStreamEventClassKind.AttemptTerminal, true, false, false,
				false, false, "stream was not opened");
		}
		if (request.reducerOutcome == null || !request.reducerOutcome.ok) {
			return outcome(request, ModelSamplingStreamHandoffKind.TerminalError, ModelSamplingStreamEventClassKind.ClosedBeforeCompleted, true, false, false,
				true, true, request.reducerOutcome == null ? "missing reducer outcome" : request.reducerOutcome.errorMessage);
		}

		final completed = !request.streamClosedBeforeCompleted && request.reducerOutcome.terminalResponseId.length > 0;
		if (!completed) {
			return outcome(request, ModelSamplingStreamHandoffKind.TerminalError, ModelSamplingStreamEventClassKind.ClosedBeforeCompleted, true, false, false,
				true, true, "stream closed before response.completed");
		}

		final needsFollowUp = request.reducerOutcome.needsFollowUp;
		return outcome(request, needsFollowUp ? ModelSamplingStreamHandoffKind.ContinueTurn : ModelSamplingStreamHandoffKind.CompleteTurn,
			needsFollowUp ? ModelSamplingStreamEventClassKind.CompletedFollowUp : ModelSamplingStreamEventClassKind.CompletedEndTurn, false, !needsFollowUp,
			needsFollowUp, true, false, "");
	}

	static function outcome(request:ModelSamplingStreamEventHandoffRequest, handoffKind:ModelSamplingStreamHandoffKind,
			eventClass:ModelSamplingStreamEventClassKind, terminal:Bool, turnEnded:Bool, continuationRequired:Bool, streamEventsConsumed:Bool,
			streamClosedBeforeCompleted:Bool, errorMessage:String):ModelSamplingStreamEventHandoffOutcome {
		final attempt = request.attemptOutcome;
		final reducer = request.reducerOutcome;
		final responseCompleted = streamEventsConsumed && !streamClosedBeforeCompleted && reducer != null && reducer.terminalResponseId.length > 0;
		final toolDrainRequired = request.inFlightToolCount > 0;
		return new ModelSamplingStreamEventHandoffOutcome(true, "sampling_stream_event_handoff_modeled", request.requestId, handoffKind, eventClass,
			attempt.resultKind, attempt.errorKind, terminal, turnEnded, continuationRequired, attempt.retryScheduled, attempt.unauthorizedRetryStatePrepared,
			streamEventsConsumed, responseCompleted, streamClosedBeforeCompleted,
			toolDrainRequired, request.tokenCountPending && toolDrainRequired, request.turnDiffPending
			&& toolDrainRequired, reducer == null ? false : reducer.needsFollowUp, responseCompleted && reducer != null ? reducer.terminalResponseId : "",
			responseCompleted
			&& reducer != null ? reducer.totalTokens : 0, responseCompleted && reducer != null ? reducer.lastAgentMessage : "", attempt.dispatchAttemptIndex,
			attempt.promptItemCount,
			attempt.liveProviderRequestAttempted, attempt.providerStreamOpened, attempt.liveNetworkAttempted || (reducer != null
				&& reducer.liveNetworkAttempted), attempt.realFilesystemMutated,
			attempt.toolExecutedOutsideFixture, errorMessage);
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingStreamEventHandoffOutcome {
		return new ModelSamplingStreamEventHandoffOutcome(false, "sampling_stream_event_handoff_failed", requestId,
			ModelSamplingStreamHandoffKind.TerminalError, ModelSamplingStreamEventClassKind.AttemptTerminal,
			ModelSamplingStreamAttemptResultKind.TerminalError, ModelSamplingStreamErrorKind.NonRetryableApiError, true, false, false, false, false, false,
			false, false, false, false, false, false, "", 0, "", 0, 0, false, false, false, false, false, errorMessage);
	}
}
