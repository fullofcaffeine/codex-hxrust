package codexhx.runtime.model.streamitem;

class ModelSamplingErrorTerminalPolicy {
	public static function handle(request:ModelSamplingErrorTerminalRequest):ModelSamplingErrorTerminalOutcome {
		if (request == null) return failure("", "missing sampling error terminal request");
		final stopHookId = request.terminalStopHookOutcome == null ? "" : request.terminalStopHookOutcome.requestId;
		final live = request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.liveNetworkAttempted;
		final fs = request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.realFilesystemMutated;
		final tool = request.terminalStopHookOutcome != null && request.terminalStopHookOutcome.toolExecutedOutsideFixture;

		return switch request.errorKind {
			case ModelSamplingErrorTerminalKind.TurnAborted:
				success(
					request,
					ModelSamplingErrorTerminalDecisionKind.BreakWithoutErrorEvent,
					stopHookId,
					true,
					true,
					false,
					false,
					false,
					false,
					false,
					false,
					"",
					false,
					true,
					live,
					fs,
					tool,
					""
				);
			case ModelSamplingErrorTerminalKind.InvalidImageRequest:
				if (request.historyImagesReplaceable) {
					success(
						request,
						ModelSamplingErrorTerminalDecisionKind.RetryAfterImageSanitization,
						stopHookId,
						true,
						false,
						true,
						true,
						true,
						false,
						false,
						false,
						"",
						true,
						false,
						live,
						fs,
						tool,
						""
					);
				} else {
					success(
						request,
						ModelSamplingErrorTerminalDecisionKind.EmitBadRequestAndBreak,
						stopHookId,
						true,
						false,
						true,
						false,
						false,
						true,
						true,
						true,
						"bad_request",
						false,
						true,
						live,
						fs,
						tool,
						"invalid image request emitted bad request error"
					);
				}
			case ModelSamplingErrorTerminalKind.GenericCodexError:
				success(
					request,
					ModelSamplingErrorTerminalDecisionKind.EmitErrorAndBreak,
					stopHookId,
					true,
					false,
					false,
					false,
					false,
					true,
					true,
					true,
					request.codexErrorInfo.length == 0 ? "unknown" : request.codexErrorInfo,
					false,
					true,
					live,
					fs,
					tool,
					"generic codex error emitted"
				);
		}
	}

	static function success(
		request:ModelSamplingErrorTerminalRequest,
		decisionKind:ModelSamplingErrorTerminalDecisionKind,
		stopHookId:String,
		stopHooksBypassed:Bool,
		turnAborted:Bool,
		invalidImageSanitizationAttempted:Bool,
		historyImagesReplaced:Bool,
		retrySamplingLoop:Bool,
		codexErrorTracked:Bool,
		lifecycleErrorEmitted:Bool,
		errorEventEmitted:Bool,
		codexErrorInfo:String,
		continueLoop:Bool,
		breakTurnLoop:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	):ModelSamplingErrorTerminalOutcome {
		return new ModelSamplingErrorTerminalOutcome(
			true,
			"sampling_error_terminal_modeled",
			request.requestId,
			request.errorKind,
			decisionKind,
			stopHookId,
			stopHooksBypassed,
			turnAborted,
			invalidImageSanitizationAttempted,
			historyImagesReplaced,
			retrySamplingLoop,
			codexErrorTracked,
			lifecycleErrorEmitted,
			errorEventEmitted,
			codexErrorInfo,
			request.previousLastAgentMessage.length > 0,
			request.previousLastAgentMessage,
			continueLoop,
			breakTurnLoop,
			liveNetworkAttempted,
			realFilesystemMutated,
			toolExecutedOutsideFixture,
			errorMessage
		);
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingErrorTerminalOutcome {
		return new ModelSamplingErrorTerminalOutcome(
			false,
			"sampling_error_terminal_failed",
			requestId,
			ModelSamplingErrorTerminalKind.GenericCodexError,
			ModelSamplingErrorTerminalDecisionKind.EmitErrorAndBreak,
			"",
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			"",
			false,
			"",
			false,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}
}
