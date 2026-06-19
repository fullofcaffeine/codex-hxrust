package codexhx.runtime.model.streamitem;

class ModelPromptPreparationPolicy {
	public static function prepare(request:ModelPromptPreparationRequest):ModelPromptPreparationOutcome {
		if (request == null)
			return failure("", "missing prompt preparation request");
		final hook = request.hookRecordingOutcome;
		if (hook == null || !hook.ok)
			return failure(request.requestId, "prompt preparation requires hook recording outcome");

		if (!hook.promptPrepContinues) {
			final decision = hook.breakBeforePrompt ? ModelPromptPreparationDecisionKind.BreakBeforePrompt : ModelPromptPreparationDecisionKind.Skipped;
			return new ModelPromptPreparationOutcome(true, "prompt_preparation_modeled", request.requestId, hook.requestId, decision, false, false, false,
				request.modelSupportsImages, request.imageItemCountBefore, 0, 0, 0, request.nextSamplingRequestIndex, false, "", false, false,
				hook.breakBeforePrompt, hook.liveNetworkAttempted, hook.realFilesystemMutated, hook.toolExecutedOutsideFixture,
				hook.breakBeforePrompt ? "blocked before prompt preparation" : "prompt preparation skipped");
		}

		if (request.windowId.length == 0)
			return failure(request.requestId, "prompt preparation requires current window id");

		final recordedPendingInputCount = hook.userInputRecordedCount + hook.responseItemRecordedCount;
		final imageItemCountAfter = request.modelSupportsImages ? request.imageItemCountBefore : 0;
		final promptItemCount = request.historyItemCount + recordedPendingInputCount;
		return new ModelPromptPreparationOutcome(true, "prompt_preparation_modeled", request.requestId, hook.requestId,
			ModelPromptPreparationDecisionKind.ContinueToDispatch, true, true, true, request.modelSupportsImages, request.imageItemCountBefore,
			imageItemCountAfter, promptItemCount, recordedPendingInputCount, request.nextSamplingRequestIndex, true, request.windowId,
			request.metadataHeaderEnabled, promptItemCount > 0 && request.windowId.length > 0, false, hook.liveNetworkAttempted, hook.realFilesystemMutated,
			hook.toolExecutedOutsideFixture, "");
	}

	static function failure(requestId:String, errorMessage:String):ModelPromptPreparationOutcome {
		return new ModelPromptPreparationOutcome(false, "prompt_preparation_failed", requestId, "", ModelPromptPreparationDecisionKind.Skipped, false, false,
			false, false, 0, 0, 0, 0, 0, false, "", false, false, false, false, false, false, errorMessage);
	}
}
