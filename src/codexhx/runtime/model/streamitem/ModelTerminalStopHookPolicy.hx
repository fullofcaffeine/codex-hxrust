package codexhx.runtime.model.streamitem;

class ModelTerminalStopHookPolicy {
	public static function run(request:ModelTerminalStopHookRequest):ModelTerminalStopHookOutcome {
		if (request == null) return failure("", "missing terminal stop hook request");
		final integration = request.integrationOutcome;
		if (integration == null || !integration.ok) return failure(request.requestId, "terminal stop hooks require sampling integration outcome");

		final promptPrepId = request.promptPreparationOutcome == null ? "" : request.promptPreparationOutcome.requestId;
		final inheritedLive = integration.liveNetworkAttempted || (request.promptPreparationOutcome != null && request.promptPreparationOutcome.liveNetworkAttempted);
		final inheritedFs = integration.realFilesystemMutated || (request.promptPreparationOutcome != null && request.promptPreparationOutcome.realFilesystemMutated);
		final inheritedTool = integration.toolExecutedOutsideFixture || (request.promptPreparationOutcome != null && request.promptPreparationOutcome.toolExecutedOutsideFixture);

		if (!integration.stopHooksEligible || request.targetKind == ModelTerminalStopHookTargetKind.InternalSubagentSkip) {
			return new ModelTerminalStopHookOutcome(
				true,
				"terminal_stop_hook_modeled",
				request.requestId,
				integration.requestId,
				promptPrepId,
				ModelTerminalStopHookDecisionKind.Skipped,
				request.targetKind,
				integration.stopHooksEligible,
				false,
				request.stopHookAlreadyActive,
				0,
				0,
				ModelTerminalStopHookRunStatusKind.Completed,
				0,
				0,
				false,
				0,
				false,
				false,
				false,
				false,
				false,
				integration.lastAgentMessage,
				false,
				integration.breakTurnLoop,
				false,
				inheritedLive,
				inheritedFs,
				inheritedTool,
				integration.stopHooksEligible ? "internal subagent lifecycle hooks skipped" : "stop hooks ineligible for this integration path"
			);
		}

		final continuationPromptRecorded = request.shouldBlock && request.continuationFragmentCount > 0 && request.continuationPromptRenderable;
		if (continuationPromptRecorded) {
			return modeled(
				request,
				integration,
				promptPrepId,
				ModelTerminalStopHookDecisionKind.ContinueWithHookPrompt,
				true,
				false,
				false,
				false,
				true,
				false,
				inheritedLive,
				inheritedFs,
				inheritedTool,
				""
			);
		}

		final warningEmitted = request.shouldBlock && !continuationPromptRecorded;
		if (request.shouldStop) {
			return modeled(
				request,
				integration,
				promptPrepId,
				ModelTerminalStopHookDecisionKind.BreakTurn,
				false,
				warningEmitted,
				false,
				false,
				false,
				true,
				inheritedLive,
				inheritedFs,
				inheritedTool,
				""
			);
		}

		final legacyAfterAgentRan = request.legacyAfterAgentEnabled;
		if (legacyAfterAgentRan && request.legacyAfterAgentAbort) {
			return modeled(
				request,
				integration,
				promptPrepId,
				ModelTerminalStopHookDecisionKind.LegacyAfterAgentAbort,
				false,
				warningEmitted,
				true,
				true,
				false,
				true,
				inheritedLive,
				inheritedFs,
				inheritedTool,
				"legacy after-agent hook aborted turn completion"
			);
		}

		return modeled(
			request,
			integration,
			promptPrepId,
			ModelTerminalStopHookDecisionKind.BreakTurn,
			false,
			warningEmitted,
			legacyAfterAgentRan,
			false,
			false,
			true,
			inheritedLive,
			inheritedFs,
			inheritedTool,
			""
		);
	}

	static function modeled(
		request:ModelTerminalStopHookRequest,
		integration:ModelSamplingResultIntegrationOutcome,
		promptPrepId:String,
		decisionKind:ModelTerminalStopHookDecisionKind,
		continuationPromptRecorded:Bool,
		warningEmitted:Bool,
		legacyAfterAgentRan:Bool,
		errorEmitted:Bool,
		continueLoop:Bool,
		breakTurnLoop:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	):ModelTerminalStopHookOutcome {
		return new ModelTerminalStopHookOutcome(
			true,
			"terminal_stop_hook_modeled",
			request.requestId,
			integration.requestId,
			promptPrepId,
			decisionKind,
			request.targetKind,
			true,
			true,
			request.stopHookAlreadyActive,
			request.previewRunCount,
			request.completedRunCount,
			request.completedRunStatusKind,
			request.previewRunCount,
			request.completedRunCount,
			request.shouldBlock,
			request.continuationFragmentCount,
			continuationPromptRecorded,
			warningEmitted,
			request.shouldStop,
			legacyAfterAgentRan,
			legacyAfterAgentRan && request.legacyAfterAgentAbort,
			integration.lastAgentMessage,
			continueLoop,
			breakTurnLoop,
			errorEmitted,
			liveNetworkAttempted,
			realFilesystemMutated,
			toolExecutedOutsideFixture,
			errorMessage
		);
	}

	static function failure(requestId:String, errorMessage:String):ModelTerminalStopHookOutcome {
		return new ModelTerminalStopHookOutcome(
			false,
			"terminal_stop_hook_failed",
			requestId,
			"",
			"",
			ModelTerminalStopHookDecisionKind.Skipped,
			ModelTerminalStopHookTargetKind.Stop,
			false,
			false,
			false,
			0,
			0,
			ModelTerminalStopHookRunStatusKind.Failed,
			0,
			0,
			false,
			0,
			false,
			false,
			false,
			false,
			false,
			"",
			false,
			false,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}
}
