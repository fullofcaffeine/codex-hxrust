package codexhx.runtime.model.streamitem;

class ModelSamplingDispatchPolicy {
	public static function plan(request:ModelSamplingDispatchRequest):ModelSamplingDispatchOutcome {
		if (request == null)
			return failure("", "missing sampling dispatch request");
		if (request.assemblyOutcome == null || !request.assemblyOutcome.ok) {
			return failure(request.requestId, "sampling dispatch requires assembled prompt input");
		}
		if (request.windowId.length == 0)
			return failure(request.requestId, "sampling dispatch requires a window id");

		final orderingPreserved = request.assemblyOutcome.historyClonedForPrompt
			&& request.assemblyOutcome.forPromptNormalized
			&& request.assemblyOutcome.assembledItemCount == request.assemblyOutcome.responseInputItemCount + request.assemblyOutcome.pendingInputItemCount;

		return new ModelSamplingDispatchOutcome(true, "sampling_dispatch_planned", request.requestId,
			request.liveProviderEnabled ? request.transportKind : ModelSamplingDispatchTransportKind.FixtureDisabled, request.windowId,
			request.turnMetadataHeaderPresent, request.assemblyOutcome.nextSamplingRequestIndex, request.assemblyOutcome.nextPromptItemCount,
			request.assemblyOutcome.assembledItemCount, request.previousDispatchCount + 1, request.maxRetries, true, true, request.modelClientSessionReused,
			request.stickyRoutingTokenPreserved, request.cancellationChildTokenCreated, orderingPreserved, false, false, false, false, false, "");
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingDispatchOutcome {
		return new ModelSamplingDispatchOutcome(false, "sampling_dispatch_failed", requestId, ModelSamplingDispatchTransportKind.FixtureDisabled, "", false,
			0, 0, 0, 0, 0, false, false, false, false, false, false, false, false, false, false, false, errorMessage);
	}
}
