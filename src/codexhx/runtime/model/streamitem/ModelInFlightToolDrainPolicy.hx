package codexhx.runtime.model.streamitem;

class ModelInFlightToolDrainPolicy {
	public static function drain(request:ModelInFlightToolDrainRequest):ModelInFlightToolDrainOutcome {
		if (request == null)
			return failure("", "missing in-flight tool drain request");
		if (request.handoffOutcome == null || !request.handoffOutcome.ok) {
			return failure(request.requestId, "in-flight drain requires a modeled stream handoff");
		}

		var responseOrderPreserved = true;
		var drained = 0;
		var convertedFailures = 0;
		var fatalFailures = 0;
		var memoryModePolluted = false;
		final parts:Array<String> = [];
		var lastOrder = 0;
		for (item in request.items) {
			if (item.orderIndex <= lastOrder)
				responseOrderPreserved = false;
			lastOrder = item.orderIndex;
			if (item.failureKind == ModelInFlightToolDrainFailureKind.FatalToolFuture) {
				fatalFailures = fatalFailures + 1;
			} else {
				drained = drained + 1;
				if (item.failureKind == ModelInFlightToolDrainFailureKind.ConvertedToolFailure || !item.success) {
					convertedFailures = convertedFailures + 1;
				}
			}
			if (item.externalContext)
				memoryModePolluted = true;
			parts.push(item.summary());
		}

		final responseInputMatches = matchesResponseInput(request);
		if (!responseInputMatches) {
			return failure(request.requestId, "drain item marked from response input does not match admitted response input");
		}

		final completed = fatalFailures == 0;
		final hasItems = request.items.length > 0;
		final drainKind = if (!hasItems) {
			ModelInFlightToolDrainOutcomeKind.NoInFlight;
		} else if (fatalFailures > 0) {
			ModelInFlightToolDrainOutcomeKind.FatalFailure;
		} else {
			ModelInFlightToolDrainOutcomeKind.Drained;
		};
		final recorded = completed && drained == request.items.length && hasItems;
		final tokenAfterDrain = completed && request.tokenCountPending;
		final turnDiffAfterDrain = completed && request.turnDiffPending;

		return new ModelInFlightToolDrainOutcome(true, "in_flight_tool_drain_modeled", request.requestId, drainKind, request.items.length, drained,
			convertedFailures, fatalFailures, responseOrderPreserved, recorded, memoryModePolluted, hasItems, tokenAfterDrain, turnDiffAfterDrain,
			tokenAfterDrain, turnDiffAfterDrain, request.handoffOutcome.liveNetworkAttempted, request.handoffOutcome.realFilesystemMutated,
			request.handoffOutcome.toolExecutedOutsideFixture, parts.join("||"), fatalFailures > 0 ? "fatal in-flight tool future failure" : "");
	}

	static function matchesResponseInput(request:ModelInFlightToolDrainRequest):Bool {
		for (item in request.items) {
			if (item.fromResponseInput) {
				final input = request.responseInputOutcome;
				if (input == null || !input.ok)
					return false;
				if (item.callId != input.callId)
					return false;
				if (item.responseKind != input.responseKind)
					return false;
				if (item.orderIndex != input.responseOrderIndex)
					return false;
				if (item.success != input.success)
					return false;
			}
		}
		return true;
	}

	static function failure(requestId:String, errorMessage:String):ModelInFlightToolDrainOutcome {
		return new ModelInFlightToolDrainOutcome(false, "in_flight_tool_drain_failed", requestId, ModelInFlightToolDrainOutcomeKind.FatalFailure, 0, 0, 0, 0,
			false, false, false, false, false, false, false, false, false, false, false, "", errorMessage);
	}
}
