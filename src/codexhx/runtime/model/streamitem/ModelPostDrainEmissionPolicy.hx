package codexhx.runtime.model.streamitem;

class ModelPostDrainEmissionPolicy {
	public static function project(request:ModelPostDrainEmissionRequest):ModelPostDrainEmissionOutcome {
		if (request == null)
			return failure("", "missing post-drain emission request");
		final drain = request.drainOutcome;
		if (drain == null || !drain.ok)
			return failure(request.requestId, "post-drain emission requires a valid drain outcome");

		final fatalDrain = drain.fatalFailureCount > 0 || drain.drainKind == ModelInFlightToolDrainOutcomeKind.FatalFailure;
		final tokenPending = drain.tokenCountEmittedAfterDrain;
		final tokenProjected = !fatalDrain && tokenPending && request.tokenInfoAvailable;
		final cancellationKind = request.cancellationRequestedAfterDrain ? ModelPostDrainCancellationKind.AfterDrainBeforeTurnDiff : ModelPostDrainCancellationKind.None;
		final turnDiffPending = drain.turnDiffEmittedAfterDrain;
		final turnDiffTrackerRead = !fatalDrain && !request.cancellationRequestedAfterDrain && turnDiffPending;
		final turnDiffProjected = turnDiffTrackerRead && request.unifiedDiffAvailable;
		final turnDiffSkippedNoDiff = turnDiffTrackerRead && !request.unifiedDiffAvailable;
		final samplingOutcomeReturned = !fatalDrain && !request.cancellationRequestedAfterDrain;
		final emissionKind = if (fatalDrain) {
			ModelPostDrainEmissionKind.FatalDrain;
		} else if (request.cancellationRequestedAfterDrain && tokenProjected) {
			ModelPostDrainEmissionKind.CancelledAfterTokenCount;
		} else if (tokenProjected && turnDiffProjected) {
			ModelPostDrainEmissionKind.TokenCountAndTurnDiff;
		} else if (tokenProjected) {
			ModelPostDrainEmissionKind.TokenCountOnly;
		} else if (turnDiffProjected) {
			ModelPostDrainEmissionKind.TurnDiffOnly;
		} else {
			ModelPostDrainEmissionKind.NoEmission;
		};

		return new ModelPostDrainEmissionOutcome(true, "post_drain_emission_modeled", request.requestId, emissionKind, cancellationKind, tokenPending,
			tokenProjected, request.tokenInfoAvailable, !fatalDrain, turnDiffPending, turnDiffTrackerRead, request.unifiedDiffAvailable, turnDiffProjected,
			request.cancellationRequestedAfterDrain
			&& turnDiffPending, turnDiffSkippedNoDiff, samplingOutcomeReturned, drain.liveNetworkAttempted,
			drain.realFilesystemMutated, drain.toolExecutedOutsideFixture, fatalDrain ? "fatal drain prevents post-drain emission" : "");
	}

	static function failure(requestId:String, errorMessage:String):ModelPostDrainEmissionOutcome {
		return new ModelPostDrainEmissionOutcome(false, "post_drain_emission_failed", requestId, ModelPostDrainEmissionKind.FatalDrain,
			ModelPostDrainCancellationKind.None, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			errorMessage);
	}
}
