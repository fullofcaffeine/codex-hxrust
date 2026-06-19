package codexhx.runtime.model.streamitem;

class ModelPendingInputHookRecordingPolicy {
	public static function record(request:ModelPendingInputHookRecordingRequest):ModelPendingInputHookRecordingOutcome {
		if (request == null)
			return failure("", "missing pending input hook recording request");
		final drain = request.drainOutcome;
		if (drain == null || !drain.ok)
			return failure(request.requestId, "pending input hook recording requires a drain outcome");

		if (!drain.hookRecordingAttempted) {
			return skipped(request, "hook recording was not attempted for this drain path");
		}

		var blockedInput = false;
		var acceptedUserInput = false;
		var userRecorded = 0;
		var responseRecorded = 0;
		var additionalContexts = 0;
		var blockedAdditionalContexts = 0;
		final summaries:Array<String> = [];

		for (item in request.items) {
			final stopped = item.shouldStop();
			if (stopped) {
				blockedInput = true;
				blockedAdditionalContexts = blockedAdditionalContexts + item.additionalContextCount;
			} else {
				if (item.isNonEmptyUserInput())
					acceptedUserInput = true;
				if (item.isUserInput()) {
					userRecorded = userRecorded + 1;
				} else {
					responseRecorded = responseRecorded + 1;
				}
			}
			additionalContexts = additionalContexts + item.additionalContextCount;
			summaries.push(item.summary(!stopped, item.additionalContextCount > 0));
		}

		final breakBeforePrompt = blockedInput && !acceptedUserInput;
		return new ModelPendingInputHookRecordingOutcome(true, "pending_input_hook_recording_modeled", request.requestId, drain.requestId,
			breakBeforePrompt ? ModelPendingInputHookRecordingDecisionKind.BreakBeforePrompt : ModelPendingInputHookRecordingDecisionKind.ContinueToPrompt,
			request.items.length, blockedInput, acceptedUserInput, userRecorded, responseRecorded, additionalContexts, blockedAdditionalContexts,
			!breakBeforePrompt, breakBeforePrompt, drain.liveNetworkAttempted, drain.realFilesystemMutated, drain.toolExecutedOutsideFixture,
			summaries.join("|"), "");
	}

	static function skipped(request:ModelPendingInputHookRecordingRequest, errorMessage:String):ModelPendingInputHookRecordingOutcome {
		final drain = request.drainOutcome;
		return new ModelPendingInputHookRecordingOutcome(true, "pending_input_hook_recording_modeled", request.requestId, drain.requestId,
			ModelPendingInputHookRecordingDecisionKind.Skipped, 0, false, false, 0, 0, 0, 0, false, false, drain.liveNetworkAttempted,
			drain.realFilesystemMutated, drain.toolExecutedOutsideFixture, "", errorMessage);
	}

	static function failure(requestId:String, errorMessage:String):ModelPendingInputHookRecordingOutcome {
		return new ModelPendingInputHookRecordingOutcome(false, "pending_input_hook_recording_failed", requestId, "",
			ModelPendingInputHookRecordingDecisionKind.Skipped, 0, false, false, 0, 0, 0, 0, false, false, false, false, false, "", errorMessage);
	}
}
