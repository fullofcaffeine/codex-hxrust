import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.model.stream.ModelStreamFixtureEvent;
import codexhx.runtime.model.stream.ModelStreamRouteRequest;
import codexhx.runtime.model.streamitem.ModelStreamItemEventKind;
import codexhx.runtime.model.streamitem.ModelStreamItemFixtureEvent;
import codexhx.runtime.model.streamitem.ModelStreamItemReducerPolicy;
import codexhx.runtime.model.streamitem.ModelStreamItemReducerReport;
import codexhx.runtime.model.streamitem.ModelStreamItemReducerRequest;
import codexhx.runtime.model.streamitem.ModelStreamOutputItem;
import codexhx.runtime.model.streamitem.ModelStreamOutputItemKind;
import codexhx.runtime.model.streamitem.ModelPatchApplicationPolicy;
import codexhx.runtime.model.streamitem.ModelPatchApplicationRequest;
import codexhx.runtime.model.streamitem.ModelPatchApplicationOutcome;
import codexhx.runtime.model.streamitem.ModelPatchApplyStatus;
import codexhx.runtime.model.streamitem.ModelPatchApprovalDecisionPolicy;
import codexhx.runtime.model.streamitem.ModelPatchApprovalDecisionRequest;
import codexhx.runtime.model.streamitem.ModelPatchApprovalDecisionOutcome;
import codexhx.runtime.model.streamitem.ModelPatchApprovalRequirement;
import codexhx.runtime.model.streamitem.ModelPatchProjectionPolicy;
import codexhx.runtime.model.streamitem.ModelPatchProjectionRequest;
import codexhx.runtime.model.streamitem.ModelPatchReviewDecision;
import codexhx.runtime.model.streamitem.ModelPatchSandboxAttemptKind;
import codexhx.runtime.model.streamitem.ModelPatchToolEventStageKind;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpOutcome;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpPolicy;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpRequest;
import codexhx.runtime.model.streamitem.ModelPatchToolOutputItemKind;
import codexhx.runtime.model.streamitem.ModelPatchToolResponseInputOutcome;
import codexhx.runtime.model.streamitem.ModelPatchToolResponseInputPolicy;
import codexhx.runtime.model.streamitem.ModelPatchToolResponseInputRequest;
import codexhx.runtime.model.streamitem.ModelSamplingContinuationPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingContinuationRequest;
import codexhx.runtime.model.streamitem.ModelSamplingContinuationOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingInputAssemblyPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingInputAssemblyRequest;
import codexhx.runtime.model.streamitem.ModelSamplingInputAssemblyOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingInputItem;
import codexhx.runtime.model.streamitem.ModelSamplingInputItemKind;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchRequest;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchTransportKind;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingStreamAttemptPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingStreamAttemptOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingStreamAttemptRequest;
import codexhx.runtime.model.streamitem.ModelSamplingStreamErrorKind;
import codexhx.runtime.model.streamitem.ModelSamplingStreamEventHandoffPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingStreamEventHandoffRequest;
import codexhx.runtime.model.streamitem.ModelSamplingStreamEventHandoffOutcome;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainFailureKind;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainItem;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainPolicy;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainRequest;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainOutcome;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionPolicy;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionRequest;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionOutcome;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionKind;
import codexhx.runtime.model.streamitem.ModelPostDrainCancellationKind;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationRequest;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationStatusKind;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainPolicy;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainRequest;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainItem;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainOutcome;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputSourceKind;
import codexhx.runtime.model.streamitem.ModelPendingInputHookActionKind;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingItem;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingOutcome;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingPolicy;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingRequest;
import codexhx.runtime.model.streamitem.ModelPromptPreparationOutcome;
import codexhx.runtime.model.streamitem.ModelPromptPreparationPolicy;
import codexhx.runtime.model.streamitem.ModelPromptPreparationRequest;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookDecisionKind;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookOutcome;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookPolicy;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookRequest;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookRunStatusKind;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookTargetKind;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerPolicy;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerOutcome;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerRequest;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerUpdateKind;
import codexhx.runtime.model.streamitem.ModelPatchAppliedDelta;
import codexhx.runtime.model.streamitem.ModelPatchVerificationPolicy;
import codexhx.runtime.model.streamitem.ModelPatchVerificationRequest;
import codexhx.runtime.model.streamitem.ModelPatchVerificationOutcome;
import codexhx.runtime.model.streamitem.ModelPatchVirtualFile;
import haxe.json.Value;
import sys.io.File;

class ModelStreamItemReducerHarness {
	static function main():Void {
		final root = fixtureRoot("fixtures/hxrust/model-stream-item-reducer.v1.json");
		final envelopeRoot = fixtureRoot(stringField(root, "envelopeFixture", "fixtures/hxrust/model-request-envelope.v1.json"));
		final routeRoot = fixtureRoot(stringField(root, "routeFixture", "fixtures/hxrust/model-stream-route.v1.json"));
		final cases = arrayField(root, "cases");
		final report = ModelStreamItemReducerPolicy.buildCases(requests(cases, envelopeRoot, routeRoot));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final testCase = objectValue(cases[i]);
			final expect = objectField(testCase, "expect");
			final outcome = report.outcomes[i];
			final secretProbe = stringField(testCase, "secretProbe", "");
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "requestId", ""), outcome.requestId);
			assertEquals(stringField(expect, "routeCode", ""), outcome.routeCode);
			assertEquals(stringField(expect, "providerId", ""), outcome.providerId);
			assertEquals(stringField(expect, "selectedModelId", ""), outcome.selectedModelId);
			assertEquals(Std.string(intField(expect, "startedCount", 0)), Std.string(outcome.startedCount));
			assertEquals(Std.string(intField(expect, "completedCount", 0)), Std.string(outcome.completedCount));
			assertEquals(Std.string(intField(expect, "assistantDeltaCount", 0)), Std.string(outcome.assistantDeltaCount));
			assertEquals(Std.string(intField(expect, "reasoningDeltaCount", 0)), Std.string(outcome.reasoningDeltaCount));
			assertEquals(Std.string(intField(expect, "rawReasoningDeltaCount", 0)), Std.string(outcome.rawReasoningDeltaCount));
			assertEquals(Std.string(intField(expect, "toolInputDeltaCount", 0)), Std.string(outcome.toolInputDeltaCount));
			assertEquals(Std.string(intField(expect, "toolInputDeltaIgnoredCount", 0)), Std.string(outcome.toolInputDeltaIgnoredCount));
			assertEquals(Std.string(intField(expect, "toolArgumentDiffEventCount", 0)), Std.string(outcome.toolArgumentDiffEventCount));
			assertEquals(Std.string(intField(expect, "toolCallCount", 0)), Std.string(outcome.toolCallCount));
			assertEquals(boolText(boolField(expect, "needsFollowUp", false)), boolText(outcome.needsFollowUp));
			assertEquals(stringField(expect, "lastAgentMessage", ""), outcome.lastAgentMessage);
			assertEquals(stringField(expect, "terminalResponseId", ""), outcome.terminalResponseId);
			assertEquals(Std.string(intField(expect, "totalTokens", 0)), Std.string(outcome.totalTokens));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
			final topLevelIntegrations = assertTopLevelSamplingResultIntegrations(testCase, outcome, secretProbe);
			final topLevelPendingInputDrains = assertTopLevelPostSamplingPendingInputDrains(testCase, topLevelIntegrations, secretProbe);
			final topLevelHookRecordings = assertTopLevelPendingInputHookRecordings(testCase, topLevelPendingInputDrains, secretProbe);
			final topLevelPromptPreparations = assertTopLevelPromptPreparations(testCase, topLevelHookRecordings, secretProbe);
			assertTopLevelTerminalStopHooks(testCase, topLevelIntegrations, topLevelPromptPreparations, secretProbe);
			assertPatchVerification(testCase, outcome);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>, envelopeRoot:Value, routeRoot:Value):Array<ModelStreamItemReducerRequest> {
		final out:Array<ModelStreamItemReducerRequest> = [];
		for (value in values) {
			final testCase = objectValue(value);
			out.push(new ModelStreamItemReducerRequest(
				stringField(testCase, "requestId", ""),
				routeRequest(testCase, envelopeRoot, routeRoot),
				itemEvents(arrayField(testCase, "events")),
				boolField(testCase, "planMode", false),
				boolField(testCase, "showRawReasoning", false),
				stringField(testCase, "secretProbe", "")
			));
		}
		return out;
	}

	static function routeRequest(testCase:Value, envelopeRoot:Value, routeRoot:Value):ModelStreamRouteRequest {
		final routeFixtureId = stringField(testCase, "routeFixtureId", "");
		if (routeFixtureId.length > 0) {
			for (value in arrayField(routeRoot, "cases")) {
				final routeCase = objectValue(value);
				if (stringField(routeCase, "id", "") == routeFixtureId) return ModelStreamRouteHarness.requests([routeCase], envelopeRoot)[0];
			}
			throw "missing stream route fixture case: " + routeFixtureId;
		}
		final route = objectField(testCase, "route");
		return new ModelStreamRouteRequest(
			stringField(route, "requestId", ""),
			ModelStreamRouteHarness.envelopeRequestById(envelopeRoot, stringField(route, "envelopeFixtureId", "")),
			stringField(route, "upstreamRequestId", ""),
			ModelStreamRouteHarness.events(arrayField(route, "events")),
			stringField(route, "secretProbe", "")
		);
	}

	static function itemEvents(values:Array<Value>):Array<ModelStreamItemFixtureEvent> {
		final out:Array<ModelStreamItemFixtureEvent> = [];
		for (value in values) {
			final event = objectValue(value);
			out.push(new ModelStreamItemFixtureEvent(
				eventKind(stringField(event, "kind", "")),
				outputItem(optionalField(event, "item")),
				stringField(event, "itemId", ""),
				stringField(event, "callId", ""),
				stringField(event, "delta", ""),
				intField(event, "summaryIndex", 0),
				intField(event, "contentIndex", 0),
				stringField(event, "responseId", ""),
				intField(event, "totalTokens", 0),
				boolField(event, "endTurn", false)
			));
		}
		return out;
	}

	static function outputItem(value:Value):ModelStreamOutputItem {
		return switch value {
			case JObject(_, _):
				new ModelStreamOutputItem(
					itemKind(stringField(value, "kind", "")),
					stringField(value, "itemId", ""),
					stringField(value, "role", ""),
					stringField(value, "text", ""),
					stringField(value, "phase", ""),
					stringArrayField(value, "summary"),
					stringArrayField(value, "rawContent"),
					stringField(value, "callId", ""),
					stringField(value, "toolName", ""),
					stringField(value, "namespace", ""),
					stringField(value, "arguments", ""),
					stringField(value, "customInput", ""),
					stringField(value, "status", "")
				);
			case _:
				null;
		}
	}

	static function eventKind(value:String):ModelStreamItemEventKind {
		return switch value {
			case "output_item_added": ModelStreamItemEventKind.OutputItemAdded;
			case "output_item_done": ModelStreamItemEventKind.OutputItemDone;
			case "output_text_delta": ModelStreamItemEventKind.OutputTextDelta;
			case "tool_call_input_delta": ModelStreamItemEventKind.ToolCallInputDelta;
			case "reasoning_summary_delta": ModelStreamItemEventKind.ReasoningSummaryDelta;
			case "reasoning_content_delta": ModelStreamItemEventKind.ReasoningContentDelta;
			case "completed": ModelStreamItemEventKind.Completed;
			case _: throw "invalid stream item event kind: " + value;
		}
	}

	static function itemKind(value:String):ModelStreamOutputItemKind {
		return switch value {
			case "assistant_message": ModelStreamOutputItemKind.AssistantMessage;
			case "reasoning": ModelStreamOutputItemKind.Reasoning;
			case "function_call": ModelStreamOutputItemKind.FunctionCall;
			case "custom_tool_call": ModelStreamOutputItemKind.CustomToolCall;
			case "web_search_call": ModelStreamOutputItemKind.WebSearchCall;
			case "image_generation_call": ModelStreamOutputItemKind.ImageGenerationCall;
			case "tool_output": ModelStreamOutputItemKind.ToolOutput;
			case "unknown": ModelStreamOutputItemKind.Unknown;
			case _: throw "invalid stream output item kind: " + value;
		}
	}

	static function assertReport(root:Value, report:ModelStreamItemReducerReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "toolCallCount", 0)), Std.string(report.toolCallCount()));
		assertEquals(Std.string(intField(expect, "toolInputDeltaCount", 0)), Std.string(report.toolInputDeltaCount()));
		assertEquals(Std.string(intField(expect, "toolInputDeltaIgnoredCount", 0)), Std.string(report.toolInputDeltaIgnoredCount()));
		assertEquals(Std.string(intField(expect, "toolArgumentDiffEventCount", 0)), Std.string(report.toolArgumentDiffEventCount()));
		assertEquals(Std.string(intField(expect, "assistantDeltaCount", 0)), Std.string(report.assistantDeltaCount()));
		assertEquals(Std.string(intField(expect, "reasoningDeltaCount", 0)), Std.string(report.reasoningDeltaCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function assertPatchVerification(testCase:Value, outcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome):Void {
		final verificationValue = optionalField(testCase, "patchVerification");
		switch verificationValue {
			case JObject(_, _):
				final expect = objectField(verificationValue, "expect");
				final beforeFiles = virtualFiles(arrayField(verificationValue, "files"));
				final verification = ModelPatchVerificationPolicy.verify(new ModelPatchVerificationRequest(
					stringField(verificationValue, "requestId", ""),
					outcome,
					stringField(verificationValue, "callId", ""),
					stringField(verificationValue, "turnId", ""),
					boolField(verificationValue, "autoApproved", false),
					patchApplyStatus(stringField(verificationValue, "desiredStatus", "completed")),
					stringField(verificationValue, "stdout", ""),
					stringField(verificationValue, "stderr", ""),
					beforeFiles,
					stringField(verificationValue, "secretProbe", "")
				));
				assertEquals(boolText(boolField(expect, "ok", false)), boolText(verification.ok));
				assertEquals(stringField(expect, "code", ""), verification.code);
				assertEquals(stringField(expect, "requestId", ""), verification.requestId);
				assertEquals(boolText(boolField(expect, "liveNetworkAttempted", false)), boolText(verification.liveNetworkAttempted));
				assertEquals(boolText(boolField(expect, "realFilesystemMutated", false)), boolText(verification.realFilesystemMutated));
				assertEquals(boolText(boolField(expect, "toolExecutedOutsideFixture", false)), boolText(verification.toolExecutedOutsideFixture));
				assertContains(verification.summary(), stringField(expect, "summaryContains", ""));
				final secretProbe = stringField(verificationValue, "secretProbe", "");
				if (secretProbe.length > 0) assertNotContains(verification.summary(), secretProbe);
				final application = assertPatchApplication(verificationValue, verification, beforeFiles, secretProbe);
				final approval = assertPatchApprovalDecision(verificationValue, verification, application, secretProbe);
				final tracker = assertPatchTurnDiffTracker(verificationValue, verification, application, approval, secretProbe);
				final projection = assertPatchProjection(verificationValue, verification, application, approval, tracker, secretProbe);
				final followUp = assertPatchToolFollowUp(verificationValue, outcome, application, projection, secretProbe);
				final responseInput = assertPatchToolResponseInput(verificationValue, followUp, secretProbe);
				final continuation = assertSamplingContinuation(verificationValue, responseInput, secretProbe);
				final assembly = assertSamplingInputAssembly(verificationValue, responseInput, continuation, secretProbe);
				final dispatch = assertSamplingDispatch(verificationValue, assembly, secretProbe);
				final attempts = assertSamplingStreamAttempts(verificationValue, dispatch, secretProbe);
				final handoffs = assertSamplingStreamEventHandoffs(verificationValue, outcome, attempts, secretProbe);
				final drains = assertInFlightToolDrains(verificationValue, responseInput, handoffs, secretProbe);
				final emissions = assertPostDrainEmissions(verificationValue, drains, secretProbe);
				final integrations = assertSamplingResultIntegrations(verificationValue, emissions, outcome, secretProbe);
				final pendingInputDrains = assertPostSamplingPendingInputDrains(verificationValue, integrations, secretProbe);
				final hookRecordings = assertPendingInputHookRecordings(verificationValue, pendingInputDrains, secretProbe);
				final promptPreparations = assertPromptPreparations(verificationValue, hookRecordings, secretProbe);
				assertTerminalStopHooks(verificationValue, integrations, promptPreparations, secretProbe);
			case JNull:
			case _:
				throw "expected object field: patchVerification";
		}
	}

	static function assertPatchApplication(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		beforeFiles:Array<ModelPatchVirtualFile>,
		secretProbe:String
	):ModelPatchApplicationOutcome {
		final applicationExpectValue = optionalField(verificationValue, "applicationExpect");
		switch applicationExpectValue {
			case JObject(_, _):
				final application = ModelPatchApplicationPolicy.apply(new ModelPatchApplicationRequest(
					stringField(applicationExpectValue, "requestId", ""),
					verification,
					beforeFiles,
					secretProbe
				));
				assertEquals(boolText(boolField(applicationExpectValue, "ok", false)), boolText(application.ok));
				assertEquals(stringField(applicationExpectValue, "code", ""), application.code);
				assertEquals(stringField(applicationExpectValue, "requestId", ""), application.requestId);
				assertEquals(stringField(applicationExpectValue, "status", ""), application.status);
				assertEquals(boolText(boolField(applicationExpectValue, "liveNetworkAttempted", false)), boolText(application.liveNetworkAttempted));
				assertEquals(boolText(boolField(applicationExpectValue, "realFilesystemMutated", false)), boolText(application.realFilesystemMutated));
				assertEquals(boolText(boolField(applicationExpectValue, "toolExecutedOutsideFixture", false)), boolText(application.toolExecutedOutsideFixture));
				assertContains(application.summary(), stringField(applicationExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(application.summary(), secretProbe);
				return application;
			case JNull:
				return null;
			case _:
				throw "expected object field: applicationExpect";
		}
	}

	static function assertPatchApprovalDecision(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		application:ModelPatchApplicationOutcome,
		secretProbe:String
	):ModelPatchApprovalDecisionOutcome {
		final approvalExpectValue = optionalField(verificationValue, "approvalExpect");
		switch approvalExpectValue {
			case JObject(_, _):
				final approval = ModelPatchApprovalDecisionPolicy.decide(new ModelPatchApprovalDecisionRequest(
					stringField(approvalExpectValue, "requestId", ""),
					verification,
					application,
					stringField(approvalExpectValue, "environmentId", ""),
					approvalRequirement(stringField(approvalExpectValue, "approvalRequirement", "skip")),
					boolField(approvalExpectValue, "permissionsPreapproved", false),
					stringField(approvalExpectValue, "additionalPermissionRoot", ""),
					stringField(approvalExpectValue, "retryReason", ""),
					boolField(approvalExpectValue, "sandboxApprovalAllowed", false),
					sandboxAttempt(stringField(approvalExpectValue, "sandboxAttempt", "none")),
					boolField(approvalExpectValue, "sandboxDenied", false),
					reviewDecision(stringField(approvalExpectValue, "reviewDecision", "denied")),
					secretProbe
				));
				assertEquals(boolText(boolField(approvalExpectValue, "ok", false)), boolText(approval.ok));
				assertEquals(stringField(approvalExpectValue, "code", ""), approval.code);
				assertEquals(stringField(approvalExpectValue, "requestId", ""), approval.requestId);
				assertEquals(boolText(boolField(approvalExpectValue, "approvalRequired", false)), boolText(approval.approvalRequired));
				assertEquals(boolText(boolField(approvalExpectValue, "approvalRequestEmitted", false)), boolText(approval.approvalRequestEmitted));
				assertEquals(boolText(boolField(approvalExpectValue, "canRun", false)), boolText(approval.canRun));
				assertEquals(boolText(boolField(approvalExpectValue, "sandboxRetryRequested", false)), boolText(approval.sandboxRetryRequested));
				assertEquals(boolText(boolField(approvalExpectValue, "liveNetworkAttempted", false)), boolText(approval.liveNetworkAttempted));
				assertEquals(boolText(boolField(approvalExpectValue, "realFilesystemMutated", false)), boolText(approval.realFilesystemMutated));
				assertEquals(boolText(boolField(approvalExpectValue, "toolExecutedOutsideFixture", false)), boolText(approval.toolExecutedOutsideFixture));
				assertContains(approval.summary(), stringField(approvalExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(approval.summary(), secretProbe);
				return approval;
			case JNull:
				return null;
			case _:
				throw "expected object field: approvalExpect";
		}
	}

	static function assertPatchTurnDiffTracker(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		application:ModelPatchApplicationOutcome,
		approval:ModelPatchApprovalDecisionOutcome,
		secretProbe:String
	):ModelPatchTurnDiffTrackerOutcome {
		final trackerExpectValue = optionalField(verificationValue, "trackerExpect");
		switch trackerExpectValue {
			case JObject(_, _):
				final tracker = ModelPatchTurnDiffTrackerPolicy.update(new ModelPatchTurnDiffTrackerRequest(
					stringField(trackerExpectValue, "requestId", ""),
					verification,
					application,
					approval,
					stringField(trackerExpectValue, "environmentId", ""),
					toolEventStage(stringField(trackerExpectValue, "stage", "success")),
					new ModelPatchAppliedDelta(
						boolField(trackerExpectValue, "deltaKnown", false),
						boolField(trackerExpectValue, "deltaExact", false),
						boolField(trackerExpectValue, "deltaFromVerification", false) && verification != null && verification.endEvent != null ? verification.endEvent.changes : []
					),
					stringField(trackerExpectValue, "previousUnifiedDiff", ""),
					secretProbe
				));
				assertEquals(boolText(boolField(trackerExpectValue, "ok", false)), boolText(tracker.ok));
				assertEquals(stringField(trackerExpectValue, "code", ""), tracker.code);
				assertEquals(stringField(trackerExpectValue, "requestId", ""), tracker.requestId);
				assertEquals(stringField(trackerExpectValue, "updateKind", ""), tracker.updateKind);
				assertEquals(boolText(boolField(trackerExpectValue, "trackerValid", false)), boolText(tracker.trackerValid));
				assertEquals(boolText(boolField(trackerExpectValue, "shouldEmitTurnDiff", false)), boolText(tracker.shouldEmitTurnDiff));
				assertEquals(boolText(boolField(trackerExpectValue, "liveNetworkAttempted", false)), boolText(tracker.liveNetworkAttempted));
				assertEquals(boolText(boolField(trackerExpectValue, "realFilesystemMutated", false)), boolText(tracker.realFilesystemMutated));
				assertEquals(boolText(boolField(trackerExpectValue, "toolExecutedOutsideFixture", false)), boolText(tracker.toolExecutedOutsideFixture));
				assertContains(tracker.summary(), stringField(trackerExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(tracker.summary(), secretProbe);
				return tracker;
			case JNull:
				return null;
			case _:
				throw "expected object field: trackerExpect";
		}
	}

	static function assertPatchProjection(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		application:ModelPatchApplicationOutcome,
		approval:ModelPatchApprovalDecisionOutcome,
		tracker:ModelPatchTurnDiffTrackerOutcome,
		secretProbe:String
	):codexhx.runtime.model.streamitem.ModelPatchProjectionOutcome {
		final projectionExpectValue = optionalField(verificationValue, "projectionExpect");
		switch projectionExpectValue {
			case JObject(_, _):
				final projection = ModelPatchProjectionPolicy.project(new ModelPatchProjectionRequest(
					stringField(projectionExpectValue, "requestId", ""),
					verification,
					application,
					approval,
					tracker,
					boolField(projectionExpectValue, "includeLegacyEvents", false),
					secretProbe
				));
				assertEquals(boolText(boolField(projectionExpectValue, "ok", false)), boolText(projection.ok));
				assertEquals(stringField(projectionExpectValue, "code", ""), projection.code);
				assertEquals(stringField(projectionExpectValue, "requestId", ""), projection.requestId);
				assertEquals(stringField(projectionExpectValue, "itemId", ""), projection.itemId);
				assertEquals(boolText(boolField(projectionExpectValue, "fileChangeItemProjected", false)), boolText(projection.fileChangeItemProjected));
				assertEquals(boolText(boolField(projectionExpectValue, "legacyBeginProjected", false)), boolText(projection.legacyBeginProjected));
				assertEquals(boolText(boolField(projectionExpectValue, "legacyEndProjected", false)), boolText(projection.legacyEndProjected));
				assertEquals(boolText(boolField(projectionExpectValue, "turnDiffProjected", false)), boolText(projection.turnDiffProjected));
				assertEquals(stringField(projectionExpectValue, "status", ""), projection.status);
				assertEquals(boolText(boolField(projectionExpectValue, "autoApproved", false)), boolText(projection.autoApproved));
				assertEquals(boolText(boolField(projectionExpectValue, "stdoutVisible", false)), boolText(projection.stdoutVisible));
				assertEquals(boolText(boolField(projectionExpectValue, "stderrVisible", false)), boolText(projection.stderrVisible));
				assertEquals(Std.string(intField(projectionExpectValue, "changeCount", 0)), Std.string(projection.changeCount));
				assertEquals(boolText(boolField(projectionExpectValue, "liveNetworkAttempted", false)), boolText(projection.liveNetworkAttempted));
				assertEquals(boolText(boolField(projectionExpectValue, "realFilesystemMutated", false)), boolText(projection.realFilesystemMutated));
				assertEquals(boolText(boolField(projectionExpectValue, "toolExecutedOutsideFixture", false)), boolText(projection.toolExecutedOutsideFixture));
				assertContains(projection.summary(), stringField(projectionExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(projection.summary(), secretProbe);
				return projection;
			case JNull:
				return null;
			case _:
				throw "expected object field: projectionExpect";
		}
	}

	static function assertPatchToolFollowUp(
		verificationValue:Value,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		application:ModelPatchApplicationOutcome,
		projection:codexhx.runtime.model.streamitem.ModelPatchProjectionOutcome,
		secretProbe:String
	):ModelPatchToolFollowUpOutcome {
		final followUpExpectValue = optionalField(verificationValue, "toolFollowUpExpect");
		switch followUpExpectValue {
			case JObject(_, _):
				final followUp = ModelPatchToolFollowUpPolicy.build(new ModelPatchToolFollowUpRequest(
					stringField(followUpExpectValue, "requestId", ""),
					reducerOutcome,
					application,
					projection,
					secretProbe
				));
				assertEquals(boolText(boolField(followUpExpectValue, "ok", false)), boolText(followUp.ok));
				assertEquals(stringField(followUpExpectValue, "code", ""), followUp.code);
				assertEquals(stringField(followUpExpectValue, "requestId", ""), followUp.requestId);
				assertEquals(stringField(followUpExpectValue, "callId", ""), followUp.callId);
				assertEquals(stringField(followUpExpectValue, "responseKind", ""), followUp.responseKind);
				assertEquals(boolText(boolField(followUpExpectValue, "success", false)), boolText(followUp.success));
				assertEquals(boolText(boolField(followUpExpectValue, "followUpQueued", false)), boolText(followUp.followUpQueued));
				assertEquals(boolText(boolField(followUpExpectValue, "modelNeedsFollowUp", false)), boolText(followUp.modelNeedsFollowUp));
				assertEquals(boolText(boolField(followUpExpectValue, "postToolUseResponseVisible", false)), boolText(followUp.postToolUseResponseVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "stdoutVisible", false)), boolText(followUp.stdoutVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "stderrVisible", false)), boolText(followUp.stderrVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "resultTextVisible", false)), boolText(followUp.resultTextVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "liveNetworkAttempted", false)), boolText(followUp.liveNetworkAttempted));
				assertEquals(boolText(boolField(followUpExpectValue, "realFilesystemMutated", false)), boolText(followUp.realFilesystemMutated));
				assertEquals(boolText(boolField(followUpExpectValue, "toolExecutedOutsideFixture", false)), boolText(followUp.toolExecutedOutsideFixture));
				assertContains(followUp.summary(), stringField(followUpExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(followUp.summary(), secretProbe);
				return followUp;
			case JNull:
				return null;
			case _:
				throw "expected object field: toolFollowUpExpect";
		}
	}

	static function assertPatchToolResponseInput(
		verificationValue:Value,
		followUp:ModelPatchToolFollowUpOutcome,
		secretProbe:String
	):ModelPatchToolResponseInputOutcome {
		final inputExpectValue = optionalField(verificationValue, "toolResponseInputExpect");
		switch inputExpectValue {
			case JObject(_, _):
				final input = ModelPatchToolResponseInputPolicy.admit(new ModelPatchToolResponseInputRequest(
					stringField(inputExpectValue, "requestId", ""),
					followUp,
					intField(inputExpectValue, "previousResponseCount", 0),
					secretProbe
				));
				assertEquals(boolText(boolField(inputExpectValue, "ok", false)), boolText(input.ok));
				assertEquals(stringField(inputExpectValue, "code", ""), input.code);
				assertEquals(stringField(inputExpectValue, "requestId", ""), input.requestId);
				assertEquals(stringField(inputExpectValue, "callId", ""), input.callId);
				assertEquals(stringField(inputExpectValue, "responseKind", ""), input.responseKind);
				assertEquals(stringField(inputExpectValue, "admissionKind", ""), input.admissionKind);
				assertEquals(Std.string(intField(inputExpectValue, "responseOrderIndex", 0)), Std.string(input.responseOrderIndex));
				assertEquals(Std.string(intField(inputExpectValue, "nextInputCount", 0)), Std.string(input.nextInputCount));
				assertEquals(boolText(boolField(inputExpectValue, "success", false)), boolText(input.success));
				assertEquals(boolText(boolField(inputExpectValue, "followUpRequestRequired", false)), boolText(input.followUpRequestRequired));
				assertEquals(boolText(boolField(inputExpectValue, "toolFutureDrained", false)), boolText(input.toolFutureDrained));
				assertEquals(boolText(boolField(inputExpectValue, "conversationItemRecorded", false)), boolText(input.conversationItemRecorded));
				assertEquals(boolText(boolField(inputExpectValue, "liveNetworkAttempted", false)), boolText(input.liveNetworkAttempted));
				assertEquals(boolText(boolField(inputExpectValue, "realFilesystemMutated", false)), boolText(input.realFilesystemMutated));
				assertEquals(boolText(boolField(inputExpectValue, "toolExecutedOutsideFixture", false)), boolText(input.toolExecutedOutsideFixture));
				assertContains(input.summary(), stringField(inputExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(input.summary(), secretProbe);
				return input;
			case JNull:
				return null;
			case _:
				throw "expected object field: toolResponseInputExpect";
		}
	}

	static function assertSamplingContinuation(
		verificationValue:Value,
		responseInput:ModelPatchToolResponseInputOutcome,
		secretProbe:String
	):ModelSamplingContinuationOutcome {
		final expectValue = optionalField(verificationValue, "samplingContinuationExpect");
		switch expectValue {
			case JObject(_, _):
				final continuation = ModelSamplingContinuationPolicy.plan(new ModelSamplingContinuationRequest(
					stringField(expectValue, "requestId", ""),
					responseInput,
					boolField(expectValue, "hasPendingInput", false),
					intField(expectValue, "pendingInputCount", 0),
					boolField(expectValue, "tokenLimitReached", false),
					intField(expectValue, "activeContextTokens", 0),
					intField(expectValue, "estimatedTokenCount", 0),
					intField(expectValue, "previousSamplingRequestCount", 0),
					secretProbe
				));
				assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(continuation.ok));
				assertEquals(stringField(expectValue, "code", ""), continuation.code);
				assertEquals(stringField(expectValue, "requestId", ""), continuation.requestId);
				assertEquals(stringField(expectValue, "continuationKind", ""), continuation.continuationKind);
				assertEquals(boolText(boolField(expectValue, "modelNeedsFollowUp", false)), boolText(continuation.modelNeedsFollowUp));
				assertEquals(boolText(boolField(expectValue, "hasPendingInput", false)), boolText(continuation.hasPendingInput));
				assertEquals(boolText(boolField(expectValue, "needsFollowUp", false)), boolText(continuation.needsFollowUp));
				assertEquals(boolText(boolField(expectValue, "nextSamplingRequestRequired", false)), boolText(continuation.nextSamplingRequestRequired));
				assertEquals(boolText(boolField(expectValue, "responseInputCarried", false)), boolText(continuation.responseInputCarried));
				assertEquals(boolText(boolField(expectValue, "pendingInputDrainedBeforeNextRequest", false)), boolText(continuation.pendingInputDrainedBeforeNextRequest));
				assertEquals(boolText(boolField(expectValue, "autoCompactRequired", false)), boolText(continuation.autoCompactRequired));
				assertEquals(boolText(boolField(expectValue, "canDrainPendingInputBeforeNextRequest", false)), boolText(continuation.canDrainPendingInputBeforeNextRequest));
				assertEquals(Std.string(intField(expectValue, "admittedResponseInputCount", 0)), Std.string(continuation.admittedResponseInputCount));
				assertEquals(Std.string(intField(expectValue, "pendingInputCount", 0)), Std.string(continuation.pendingInputCount));
				assertEquals(Std.string(intField(expectValue, "nextSamplingInputCount", 0)), Std.string(continuation.nextSamplingInputCount));
				assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(continuation.nextSamplingRequestIndex));
				assertEquals(Std.string(intField(expectValue, "activeContextTokens", 0)), Std.string(continuation.activeContextTokens));
				assertEquals(Std.string(intField(expectValue, "estimatedTokenCount", 0)), Std.string(continuation.estimatedTokenCount));
				assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(continuation.liveNetworkAttempted));
				assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(continuation.realFilesystemMutated));
				assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(continuation.toolExecutedOutsideFixture));
				assertContains(continuation.summary(), stringField(expectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(continuation.summary(), secretProbe);
				return continuation;
			case JNull:
				return null;
			case _:
				throw "expected object field: samplingContinuationExpect";
		}
	}

	static function assertSamplingInputAssembly(
		verificationValue:Value,
		responseInput:ModelPatchToolResponseInputOutcome,
		continuation:ModelSamplingContinuationOutcome,
		secretProbe:String
	):ModelSamplingInputAssemblyOutcome {
		final expectValue = optionalField(verificationValue, "samplingInputAssemblyExpect");
		switch expectValue {
			case JObject(_, _):
				final assembly = ModelSamplingInputAssemblyPolicy.assemble(new ModelSamplingInputAssemblyRequest(
					stringField(expectValue, "requestId", ""),
					responseInput,
					continuation,
					samplingInputItems(arrayField(expectValue, "pendingInputItems")),
					intField(expectValue, "previousPromptItemCount", 0),
					boolField(expectValue, "modelSupportsImages", false),
					secretProbe
				));
				assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(assembly.ok));
				assertEquals(stringField(expectValue, "code", ""), assembly.code);
				assertEquals(stringField(expectValue, "requestId", ""), assembly.requestId);
				assertEquals(stringField(expectValue, "continuationKind", ""), assembly.continuationKind);
				assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(assembly.nextSamplingRequestIndex));
				assertEquals(Std.string(intField(expectValue, "previousPromptItemCount", 0)), Std.string(assembly.previousPromptItemCount));
				assertEquals(Std.string(intField(expectValue, "assembledItemCount", 0)), Std.string(assembly.assembledItemCount));
				assertEquals(Std.string(intField(expectValue, "nextPromptItemCount", 0)), Std.string(assembly.nextPromptItemCount));
				assertEquals(Std.string(intField(expectValue, "responseInputItemCount", 0)), Std.string(assembly.responseInputItemCount));
				assertEquals(Std.string(intField(expectValue, "pendingInputItemCount", 0)), Std.string(assembly.pendingInputItemCount));
				assertEquals(boolText(boolField(expectValue, "pendingInputDrained", false)), boolText(assembly.pendingInputDrained));
				assertEquals(boolText(boolField(expectValue, "historyClonedForPrompt", false)), boolText(assembly.historyClonedForPrompt));
				assertEquals(boolText(boolField(expectValue, "forPromptNormalized", false)), boolText(assembly.forPromptNormalized));
				assertEquals(boolText(boolField(expectValue, "modelSupportsImages", false)), boolText(assembly.modelSupportsImages));
				assertEquals(stringField(expectValue, "firstItemKind", ""), assembly.firstItemKind);
				assertEquals(stringField(expectValue, "lastItemKind", ""), assembly.lastItemKind);
				assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(assembly.liveNetworkAttempted));
				assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(assembly.realFilesystemMutated));
				assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(assembly.toolExecutedOutsideFixture));
				assertContains(assembly.summary(), stringField(expectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(assembly.summary(), secretProbe);
				return assembly;
			case JNull:
				return null;
			case _:
				throw "expected object field: samplingInputAssemblyExpect";
		}
	}

	static function assertSamplingDispatch(
		verificationValue:Value,
		assembly:ModelSamplingInputAssemblyOutcome,
		secretProbe:String
	):ModelSamplingDispatchOutcome {
		final expectValue = optionalField(verificationValue, "samplingDispatchExpect");
		switch expectValue {
			case JObject(_, _):
				final dispatch = ModelSamplingDispatchPolicy.plan(new ModelSamplingDispatchRequest(
					stringField(expectValue, "requestId", ""),
					assembly,
					samplingDispatchTransportKind(stringField(expectValue, "requestedTransportKind", "responses_http")),
					stringField(expectValue, "windowId", ""),
					boolField(expectValue, "turnMetadataHeaderPresent", false),
					intField(expectValue, "maxRetries", 0),
					intField(expectValue, "previousDispatchCount", 0),
					boolField(expectValue, "modelClientSessionReused", false),
					boolField(expectValue, "stickyRoutingTokenPreserved", false),
					boolField(expectValue, "cancellationChildTokenCreated", false),
					boolField(expectValue, "liveProviderEnabled", false),
					secretProbe
				));
				assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(dispatch.ok));
				assertEquals(stringField(expectValue, "code", ""), dispatch.code);
				assertEquals(stringField(expectValue, "requestId", ""), dispatch.requestId);
				assertEquals(stringField(expectValue, "transportKind", ""), dispatch.transportKind);
				assertEquals(stringField(expectValue, "windowId", ""), dispatch.windowId);
				assertEquals(boolText(boolField(expectValue, "turnMetadataHeaderPresent", false)), boolText(dispatch.turnMetadataHeaderPresent));
				assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(dispatch.nextSamplingRequestIndex));
				assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(dispatch.promptItemCount));
				assertEquals(Std.string(intField(expectValue, "assembledItemCount", 0)), Std.string(dispatch.assembledItemCount));
				assertEquals(Std.string(intField(expectValue, "dispatchAttemptIndex", 0)), Std.string(dispatch.dispatchAttemptIndex));
				assertEquals(Std.string(intField(expectValue, "maxRetries", 0)), Std.string(dispatch.maxRetries));
				assertEquals(boolText(boolField(expectValue, "retryStateInitialized", false)), boolText(dispatch.retryStateInitialized));
				assertEquals(boolText(boolField(expectValue, "modelClientSessionTurnScoped", false)), boolText(dispatch.modelClientSessionTurnScoped));
				assertEquals(boolText(boolField(expectValue, "modelClientSessionReused", false)), boolText(dispatch.modelClientSessionReused));
				assertEquals(boolText(boolField(expectValue, "stickyRoutingTokenPreserved", false)), boolText(dispatch.stickyRoutingTokenPreserved));
				assertEquals(boolText(boolField(expectValue, "cancellationChildTokenCreated", false)), boolText(dispatch.cancellationChildTokenCreated));
				assertEquals(boolText(boolField(expectValue, "promptOrderingPreserved", false)), boolText(dispatch.promptOrderingPreserved));
				assertEquals(boolText(boolField(expectValue, "liveProviderRequestAttempted", false)), boolText(dispatch.liveProviderRequestAttempted));
				assertEquals(boolText(boolField(expectValue, "providerStreamOpened", false)), boolText(dispatch.providerStreamOpened));
				assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(dispatch.liveNetworkAttempted));
				assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(dispatch.realFilesystemMutated));
				assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(dispatch.toolExecutedOutsideFixture));
				assertContains(dispatch.summary(), stringField(expectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(dispatch.summary(), secretProbe);
				return dispatch;
			case JNull:
				return null;
			case _:
				throw "expected object field: samplingDispatchExpect";
		}
	}

	static function assertSamplingStreamAttempts(
		verificationValue:Value,
		dispatch:ModelSamplingDispatchOutcome,
		secretProbe:String
	):Array<ModelSamplingStreamAttemptOutcome> {
		final attempts:Array<ModelSamplingStreamAttemptOutcome> = [];
		final values = arrayField(verificationValue, "samplingStreamAttemptExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final attempt = ModelSamplingStreamAttemptPolicy.evaluate(new ModelSamplingStreamAttemptRequest(
				stringField(expectValue, "requestId", ""),
				dispatch,
				samplingStreamErrorKind(stringField(expectValue, "errorKind", "none")),
				intField(expectValue, "currentRetryCount", 0),
				boolField(expectValue, "unauthorizedRecoveryAvailable", false),
				boolField(expectValue, "rateLimitUpdated", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(attempt.ok));
			assertEquals(stringField(expectValue, "code", ""), attempt.code);
			assertEquals(stringField(expectValue, "requestId", ""), attempt.requestId);
			assertEquals(stringField(expectValue, "resultKind", ""), attempt.resultKind);
			assertEquals(stringField(expectValue, "errorKind", ""), attempt.errorKind);
			assertEquals(boolText(boolField(expectValue, "retryable", false)), boolText(attempt.retryable));
			assertEquals(boolText(boolField(expectValue, "retryScheduled", false)), boolText(attempt.retryScheduled));
			assertEquals(Std.string(intField(expectValue, "retryCountBefore", 0)), Std.string(attempt.retryCountBefore));
			assertEquals(Std.string(intField(expectValue, "retryCountAfter", 0)), Std.string(attempt.retryCountAfter));
			assertEquals(Std.string(intField(expectValue, "maxRetries", 0)), Std.string(attempt.maxRetries));
			assertEquals(boolText(boolField(expectValue, "unauthorizedRetryStatePrepared", false)), boolText(attempt.unauthorizedRetryStatePrepared));
			assertEquals(boolText(boolField(expectValue, "contextWindowMarkedFull", false)), boolText(attempt.contextWindowMarkedFull));
			assertEquals(boolText(boolField(expectValue, "usageLimitRateLimitsUpdated", false)), boolText(attempt.usageLimitRateLimitsUpdated));
			assertEquals(boolText(boolField(expectValue, "terminal", false)), boolText(attempt.terminal));
			assertEquals(boolText(boolField(expectValue, "streamOpened", false)), boolText(attempt.streamOpened));
			assertEquals(Std.string(intField(expectValue, "dispatchAttemptIndex", 0)), Std.string(attempt.dispatchAttemptIndex));
			assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(attempt.promptItemCount));
			assertEquals(boolText(boolField(expectValue, "liveProviderRequestAttempted", false)), boolText(attempt.liveProviderRequestAttempted));
			assertEquals(boolText(boolField(expectValue, "providerStreamOpened", false)), boolText(attempt.providerStreamOpened));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(attempt.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(attempt.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(attempt.toolExecutedOutsideFixture));
			assertContains(attempt.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(attempt.summary(), secretProbe);
			attempts.push(attempt);
		}
		return attempts;
	}

	static function assertSamplingStreamEventHandoffs(
		verificationValue:Value,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		attempts:Array<ModelSamplingStreamAttemptOutcome>,
		secretProbe:String
	):Array<ModelSamplingStreamEventHandoffOutcome> {
		final handoffs:Array<ModelSamplingStreamEventHandoffOutcome> = [];
		final values = optionalArrayField(verificationValue, "samplingStreamEventHandoffExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final handoff = ModelSamplingStreamEventHandoffPolicy.model(new ModelSamplingStreamEventHandoffRequest(
				stringField(expectValue, "requestId", ""),
				streamAttemptByRequestId(attempts, stringField(expectValue, "attemptRequestId", "")),
				reducerOutcome,
				boolField(expectValue, "streamClosedBeforeCompleted", false),
				intField(expectValue, "inFlightToolCount", 0),
				boolField(expectValue, "tokenCountPending", false),
				boolField(expectValue, "turnDiffPending", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(handoff.ok));
			assertEquals(stringField(expectValue, "code", ""), handoff.code);
			assertEquals(stringField(expectValue, "requestId", ""), handoff.requestId);
			assertEquals(stringField(expectValue, "handoffKind", ""), handoff.handoffKind);
			assertEquals(stringField(expectValue, "eventClass", ""), handoff.eventClass);
			assertEquals(stringField(expectValue, "attemptResultKind", ""), handoff.attemptResultKind);
			assertEquals(stringField(expectValue, "attemptErrorKind", ""), handoff.attemptErrorKind);
			assertEquals(boolText(boolField(expectValue, "terminal", false)), boolText(handoff.terminal));
			assertEquals(boolText(boolField(expectValue, "turnEnded", false)), boolText(handoff.turnEnded));
			assertEquals(boolText(boolField(expectValue, "continuationRequired", false)), boolText(handoff.continuationRequired));
			assertEquals(boolText(boolField(expectValue, "retryScheduled", false)), boolText(handoff.retryScheduled));
			assertEquals(boolText(boolField(expectValue, "unauthorizedRetryStatePrepared", false)), boolText(handoff.unauthorizedRetryStatePrepared));
			assertEquals(boolText(boolField(expectValue, "streamEventsConsumed", false)), boolText(handoff.streamEventsConsumed));
			assertEquals(boolText(boolField(expectValue, "responseCompleted", false)), boolText(handoff.responseCompleted));
			assertEquals(boolText(boolField(expectValue, "streamClosedBeforeCompleted", false)), boolText(handoff.streamClosedBeforeCompleted));
			assertEquals(boolText(boolField(expectValue, "toolDrainRequired", false)), boolText(handoff.toolDrainRequired));
			assertEquals(boolText(boolField(expectValue, "tokenCountEventDeferredUntilToolDrain", false)), boolText(handoff.tokenCountEventDeferredUntilToolDrain));
			assertEquals(boolText(boolField(expectValue, "turnDiffEventDeferredUntilToolDrain", false)), boolText(handoff.turnDiffEventDeferredUntilToolDrain));
			assertEquals(boolText(boolField(expectValue, "needsFollowUp", false)), boolText(handoff.needsFollowUp));
			assertEquals(stringField(expectValue, "terminalResponseId", ""), handoff.terminalResponseId);
			assertEquals(Std.string(intField(expectValue, "totalTokens", 0)), Std.string(handoff.totalTokens));
			assertEquals(stringField(expectValue, "lastAgentMessage", ""), handoff.lastAgentMessage);
			assertEquals(Std.string(intField(expectValue, "dispatchAttemptIndex", 0)), Std.string(handoff.dispatchAttemptIndex));
			assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(handoff.promptItemCount));
			assertEquals(boolText(boolField(expectValue, "liveProviderRequestAttempted", false)), boolText(handoff.liveProviderRequestAttempted));
			assertEquals(boolText(boolField(expectValue, "providerStreamOpened", false)), boolText(handoff.providerStreamOpened));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(handoff.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(handoff.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(handoff.toolExecutedOutsideFixture));
			assertContains(handoff.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(handoff.summary(), secretProbe);
			handoffs.push(handoff);
		}
		return handoffs;
	}

	static function streamAttemptByRequestId(attempts:Array<ModelSamplingStreamAttemptOutcome>, requestId:String):ModelSamplingStreamAttemptOutcome {
		for (attempt in attempts) if (attempt.requestId == requestId) return attempt;
		throw "missing stream attempt outcome: " + requestId;
	}

	static function assertInFlightToolDrains(
		verificationValue:Value,
		responseInput:ModelPatchToolResponseInputOutcome,
		handoffs:Array<ModelSamplingStreamEventHandoffOutcome>,
		secretProbe:String
	):Array<ModelInFlightToolDrainOutcome> {
		final drains:Array<ModelInFlightToolDrainOutcome> = [];
		final values = optionalArrayField(verificationValue, "inFlightToolDrainExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final drain = ModelInFlightToolDrainPolicy.drain(new ModelInFlightToolDrainRequest(
				stringField(expectValue, "requestId", ""),
				streamHandoffByRequestId(handoffs, stringField(expectValue, "handoffRequestId", "")),
				responseInput,
				inFlightDrainItems(arrayField(expectValue, "items")),
				boolField(expectValue, "tokenCountPending", false),
				boolField(expectValue, "turnDiffPending", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(drain.ok));
			assertEquals(stringField(expectValue, "code", ""), drain.code);
			assertEquals(stringField(expectValue, "requestId", ""), drain.requestId);
			assertEquals(stringField(expectValue, "drainKind", ""), drain.drainKind);
			assertEquals(Std.string(intField(expectValue, "itemCount", 0)), Std.string(drain.itemCount));
			assertEquals(Std.string(intField(expectValue, "drainedItemCount", 0)), Std.string(drain.drainedItemCount));
			assertEquals(Std.string(intField(expectValue, "convertedFailureCount", 0)), Std.string(drain.convertedFailureCount));
			assertEquals(Std.string(intField(expectValue, "fatalFailureCount", 0)), Std.string(drain.fatalFailureCount));
			assertEquals(boolText(boolField(expectValue, "responseOrderPreserved", false)), boolText(drain.responseOrderPreserved));
			assertEquals(boolText(boolField(expectValue, "conversationItemsRecorded", false)), boolText(drain.conversationItemsRecorded));
			assertEquals(boolText(boolField(expectValue, "memoryModePolluted", false)), boolText(drain.memoryModePolluted));
			assertEquals(boolText(boolField(expectValue, "toolBlockingTimingStarted", false)), boolText(drain.toolBlockingTimingStarted));
			assertEquals(boolText(boolField(expectValue, "drainCompletedBeforeTokenCount", false)), boolText(drain.drainCompletedBeforeTokenCount));
			assertEquals(boolText(boolField(expectValue, "drainCompletedBeforeTurnDiff", false)), boolText(drain.drainCompletedBeforeTurnDiff));
			assertEquals(boolText(boolField(expectValue, "tokenCountEmittedAfterDrain", false)), boolText(drain.tokenCountEmittedAfterDrain));
			assertEquals(boolText(boolField(expectValue, "turnDiffEmittedAfterDrain", false)), boolText(drain.turnDiffEmittedAfterDrain));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(drain.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(drain.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(drain.toolExecutedOutsideFixture));
			assertContains(drain.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(drain.summary(), secretProbe);
			drains.push(drain);
		}
		return drains;
	}

	static function assertPostDrainEmissions(
		verificationValue:Value,
		drains:Array<ModelInFlightToolDrainOutcome>,
		secretProbe:String
	):Array<ModelPostDrainEmissionOutcome> {
		final emissions:Array<ModelPostDrainEmissionOutcome> = [];
		final values = optionalArrayField(verificationValue, "postDrainEmissionExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final emission = ModelPostDrainEmissionPolicy.project(new ModelPostDrainEmissionRequest(
				stringField(expectValue, "requestId", ""),
				drainByRequestId(drains, stringField(expectValue, "drainRequestId", "")),
				boolField(expectValue, "cancellationRequestedAfterDrain", false),
				boolField(expectValue, "unifiedDiffAvailable", false),
				boolField(expectValue, "tokenInfoAvailable", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(emission.ok));
			assertEquals(stringField(expectValue, "code", ""), emission.code);
			assertEquals(stringField(expectValue, "requestId", ""), emission.requestId);
			assertEquals(stringField(expectValue, "emissionKind", ""), emission.emissionKind);
			assertEquals(stringField(expectValue, "cancellationKind", ""), emission.cancellationKind);
			assertEquals(boolText(boolField(expectValue, "tokenCountPending", false)), boolText(emission.tokenCountPending));
			assertEquals(boolText(boolField(expectValue, "tokenCountProjected", false)), boolText(emission.tokenCountProjected));
			assertEquals(boolText(boolField(expectValue, "tokenInfoAvailable", false)), boolText(emission.tokenInfoAvailable));
			assertEquals(boolText(boolField(expectValue, "cancellationCheckedAfterTokenCount", false)), boolText(emission.cancellationCheckedAfterTokenCount));
			assertEquals(boolText(boolField(expectValue, "turnDiffPending", false)), boolText(emission.turnDiffPending));
			assertEquals(boolText(boolField(expectValue, "turnDiffTrackerRead", false)), boolText(emission.turnDiffTrackerRead));
			assertEquals(boolText(boolField(expectValue, "unifiedDiffAvailable", false)), boolText(emission.unifiedDiffAvailable));
			assertEquals(boolText(boolField(expectValue, "turnDiffProjected", false)), boolText(emission.turnDiffProjected));
			assertEquals(boolText(boolField(expectValue, "turnDiffSkippedByCancellation", false)), boolText(emission.turnDiffSkippedByCancellation));
			assertEquals(boolText(boolField(expectValue, "turnDiffSkippedNoDiff", false)), boolText(emission.turnDiffSkippedNoDiff));
			assertEquals(boolText(boolField(expectValue, "samplingOutcomeReturned", false)), boolText(emission.samplingOutcomeReturned));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(emission.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(emission.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(emission.toolExecutedOutsideFixture));
			assertContains(emission.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(emission.summary(), secretProbe);
			emissions.push(emission);
		}
		return emissions;
	}

	static function drainByRequestId(drains:Array<ModelInFlightToolDrainOutcome>, requestId:String):ModelInFlightToolDrainOutcome {
		for (drain in drains) if (drain.requestId == requestId) return drain;
		throw "missing in-flight tool drain outcome: " + requestId;
	}

	static function assertTopLevelSamplingResultIntegrations(
		testCase:Value,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		secretProbe:String
	):Array<ModelSamplingResultIntegrationOutcome> {
		final integrations:Array<ModelSamplingResultIntegrationOutcome> = [];
		final values = optionalArrayField(testCase, "samplingResultIntegrationExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final syntheticEmission = new ModelPostDrainEmissionOutcome(
				true,
				"post_drain_emission_modeled",
				stringField(expectValue, "postDrainRequestId", "synthetic-post-drain"),
				ModelPostDrainEmissionKind.NoEmission,
				ModelPostDrainCancellationKind.None,
				false,
				false,
				false,
				true,
				false,
				false,
				false,
				false,
				false,
				false,
				boolField(expectValue, "samplingOutcomeReturned", true),
				reducerOutcome.liveNetworkAttempted,
				false,
				false,
				""
			);
			integrations.push(assertSamplingResultIntegration(expectValue, syntheticEmission, reducerOutcome, secretProbe));
		}
		return integrations;
	}

	static function assertSamplingResultIntegrations(
		verificationValue:Value,
		emissions:Array<ModelPostDrainEmissionOutcome>,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		secretProbe:String
	):Array<ModelSamplingResultIntegrationOutcome> {
		final integrations:Array<ModelSamplingResultIntegrationOutcome> = [];
		final values = optionalArrayField(verificationValue, "samplingResultIntegrationExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			integrations.push(assertSamplingResultIntegration(expectValue, postDrainEmissionByRequestId(emissions, stringField(expectValue, "postDrainRequestId", "")), reducerOutcome, secretProbe));
		}
		return integrations;
	}

	static function assertSamplingResultIntegration(
		expectValue:Value,
		emission:ModelPostDrainEmissionOutcome,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		secretProbe:String
	):ModelSamplingResultIntegrationOutcome {
		final integration = ModelSamplingResultIntegrationPolicy.integrate(new ModelSamplingResultIntegrationRequest(
			stringField(expectValue, "requestId", ""),
			emission,
			boolField(expectValue, "modelNeedsFollowUp", reducerOutcome.needsFollowUp),
			boolField(expectValue, "hasPendingInput", false),
			intField(expectValue, "pendingInputCount", 0),
			boolField(expectValue, "tokenLimitReached", false),
			stringField(expectValue, "lastAgentMessage", reducerOutcome.lastAgentMessage),
			stringField(expectValue, "previousLastAgentMessage", ""),
			samplingResultStatusKind(stringField(expectValue, "statusKind", "ok")),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(integration.ok));
		assertEquals(stringField(expectValue, "code", ""), integration.code);
		assertEquals(stringField(expectValue, "requestId", ""), integration.requestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), integration.decisionKind);
		assertEquals(stringField(expectValue, "statusKind", ""), integration.statusKind);
		assertEquals(boolText(boolField(expectValue, "needsFollowUp", false)), boolText(integration.needsFollowUp));
		assertEquals(boolText(boolField(expectValue, "pendingInputDrainEnabled", false)), boolText(integration.pendingInputDrainEnabled));
		assertEquals(boolText(boolField(expectValue, "canDrainPendingInputAfterAutoCompact", false)), boolText(integration.canDrainPendingInputAfterAutoCompact));
		assertEquals(boolText(boolField(expectValue, "lastAgentMessageUpdated", false)), boolText(integration.lastAgentMessageUpdated));
		assertEquals(stringField(expectValue, "integratedLastAgentMessage", ""), integration.lastAgentMessage);
		assertEquals(boolText(boolField(expectValue, "samplingOutcomeReturned", false)), boolText(integration.samplingOutcomeReturned));
		assertEquals(boolText(boolField(expectValue, "stopHooksEligible", false)), boolText(integration.stopHooksEligible));
		assertEquals(boolText(boolField(expectValue, "continueLoop", false)), boolText(integration.continueLoop));
		assertEquals(boolText(boolField(expectValue, "breakTurnLoop", false)), boolText(integration.breakTurnLoop));
		assertEquals(boolText(boolField(expectValue, "bypassedForCancellation", false)), boolText(integration.bypassedForCancellation));
		assertEquals(boolText(boolField(expectValue, "bypassedForError", false)), boolText(integration.bypassedForError));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(integration.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(integration.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(integration.toolExecutedOutsideFixture));
		assertContains(integration.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(integration.summary(), secretProbe);
		return integration;
	}

	static function assertTopLevelPostSamplingPendingInputDrains(
		testCase:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		secretProbe:String
	):Array<ModelPostSamplingPendingInputDrainOutcome> {
		final drains:Array<ModelPostSamplingPendingInputDrainOutcome> = [];
		final values = optionalArrayField(testCase, "postSamplingPendingInputDrainExpects");
		for (value in values) drains.push(assertPostSamplingPendingInputDrain(objectValue(value), integrations, secretProbe));
		return drains;
	}

	static function assertPostSamplingPendingInputDrains(
		verificationValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		secretProbe:String
	):Array<ModelPostSamplingPendingInputDrainOutcome> {
		final drains:Array<ModelPostSamplingPendingInputDrainOutcome> = [];
		final values = optionalArrayField(verificationValue, "postSamplingPendingInputDrainExpects");
		for (value in values) drains.push(assertPostSamplingPendingInputDrain(objectValue(value), integrations, secretProbe));
		return drains;
	}

	static function assertPostSamplingPendingInputDrain(
		expectValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		secretProbe:String
	):ModelPostSamplingPendingInputDrainOutcome {
		final drain = ModelPostSamplingPendingInputDrainPolicy.drain(new ModelPostSamplingPendingInputDrainRequest(
			stringField(expectValue, "requestId", ""),
			samplingResultIntegrationByRequestId(integrations, stringField(expectValue, "integrationRequestId", "")),
			postSamplingPendingInputItems(optionalArrayField(expectValue, "activeTurnItems")),
			postSamplingPendingInputItems(optionalArrayField(expectValue, "mailboxItems")),
			boolField(expectValue, "acceptsMailboxDelivery", true),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(drain.ok));
		assertEquals(stringField(expectValue, "code", ""), drain.code);
		assertEquals(stringField(expectValue, "requestId", ""), drain.requestId);
		assertEquals(stringField(expectValue, "integrationRequestId", ""), drain.integrationRequestId);
		assertEquals(stringField(expectValue, "drainKind", ""), drain.drainKind);
		assertEquals(boolText(boolField(expectValue, "canDrainPendingInput", false)), boolText(drain.canDrainPendingInput));
		assertEquals(boolText(boolField(expectValue, "acceptsMailboxDelivery", true)), boolText(drain.acceptsMailboxDelivery));
		assertEquals(Std.string(intField(expectValue, "activeTurnItemCount", 0)), Std.string(drain.activeTurnItemCount));
		assertEquals(Std.string(intField(expectValue, "mailboxItemCount", 0)), Std.string(drain.mailboxItemCount));
		assertEquals(Std.string(intField(expectValue, "drainedItemCount", 0)), Std.string(drain.drainedItemCount));
		assertEquals(Std.string(intField(expectValue, "userInputRecordedCount", 0)), Std.string(drain.userInputRecordedCount));
		assertEquals(Std.string(intField(expectValue, "responseItemRecordedCount", 0)), Std.string(drain.responseItemRecordedCount));
		assertEquals(boolText(boolField(expectValue, "mailboxAppendedAfterActiveTurn", true)), boolText(drain.mailboxAppendedAfterActiveTurn));
		assertEquals(boolText(boolField(expectValue, "hookRecordingAttempted", false)), boolText(drain.hookRecordingAttempted));
		assertEquals(boolText(boolField(expectValue, "promptAssemblyAfterHooks", false)), boolText(drain.promptAssemblyAfterHooks));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(drain.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(drain.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(drain.toolExecutedOutsideFixture));
		assertContains(drain.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(drain.summary(), secretProbe);
		return drain;
	}

	static function assertTopLevelPendingInputHookRecordings(
		testCase:Value,
		drains:Array<ModelPostSamplingPendingInputDrainOutcome>,
		secretProbe:String
	):Array<ModelPendingInputHookRecordingOutcome> {
		final recordings:Array<ModelPendingInputHookRecordingOutcome> = [];
		final values = optionalArrayField(testCase, "pendingInputHookRecordingExpects");
		for (value in values) recordings.push(assertPendingInputHookRecording(objectValue(value), drains, secretProbe));
		return recordings;
	}

	static function assertPendingInputHookRecordings(
		verificationValue:Value,
		drains:Array<ModelPostSamplingPendingInputDrainOutcome>,
		secretProbe:String
	):Array<ModelPendingInputHookRecordingOutcome> {
		final recordings:Array<ModelPendingInputHookRecordingOutcome> = [];
		final values = optionalArrayField(verificationValue, "pendingInputHookRecordingExpects");
		for (value in values) recordings.push(assertPendingInputHookRecording(objectValue(value), drains, secretProbe));
		return recordings;
	}

	static function assertPendingInputHookRecording(
		expectValue:Value,
		drains:Array<ModelPostSamplingPendingInputDrainOutcome>,
		secretProbe:String
	):ModelPendingInputHookRecordingOutcome {
		final recording = ModelPendingInputHookRecordingPolicy.record(new ModelPendingInputHookRecordingRequest(
			stringField(expectValue, "requestId", ""),
			postSamplingPendingInputDrainByRequestId(drains, stringField(expectValue, "drainRequestId", "")),
			pendingInputHookRecordingItems(optionalArrayField(expectValue, "items")),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(recording.ok));
		assertEquals(stringField(expectValue, "code", ""), recording.code);
		assertEquals(stringField(expectValue, "requestId", ""), recording.requestId);
		assertEquals(stringField(expectValue, "drainRequestId", ""), recording.drainRequestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), recording.decisionKind);
		assertEquals(Std.string(intField(expectValue, "hookItemCount", 0)), Std.string(recording.hookItemCount));
		assertEquals(boolText(boolField(expectValue, "blockedInput", false)), boolText(recording.blockedInput));
		assertEquals(boolText(boolField(expectValue, "acceptedUserInput", false)), boolText(recording.acceptedUserInput));
		assertEquals(Std.string(intField(expectValue, "userInputRecordedCount", 0)), Std.string(recording.userInputRecordedCount));
		assertEquals(Std.string(intField(expectValue, "responseItemRecordedCount", 0)), Std.string(recording.responseItemRecordedCount));
		assertEquals(Std.string(intField(expectValue, "additionalContextRecordedCount", 0)), Std.string(recording.additionalContextRecordedCount));
		assertEquals(Std.string(intField(expectValue, "blockedAdditionalContextRecordedCount", 0)), Std.string(recording.blockedAdditionalContextRecordedCount));
		assertEquals(boolText(boolField(expectValue, "promptPrepContinues", false)), boolText(recording.promptPrepContinues));
		assertEquals(boolText(boolField(expectValue, "breakBeforePrompt", false)), boolText(recording.breakBeforePrompt));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(recording.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(recording.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(recording.toolExecutedOutsideFixture));
		assertContains(recording.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(recording.summary(), secretProbe);
		return recording;
	}

	static function assertTopLevelPromptPreparations(
		testCase:Value,
		hookRecordings:Array<ModelPendingInputHookRecordingOutcome>,
		secretProbe:String
	):Array<ModelPromptPreparationOutcome> {
		final preparations:Array<ModelPromptPreparationOutcome> = [];
		final values = optionalArrayField(testCase, "promptPreparationExpects");
		for (value in values) preparations.push(assertPromptPreparation(objectValue(value), hookRecordings, secretProbe));
		return preparations;
	}

	static function assertPromptPreparations(
		verificationValue:Value,
		hookRecordings:Array<ModelPendingInputHookRecordingOutcome>,
		secretProbe:String
	):Array<ModelPromptPreparationOutcome> {
		final preparations:Array<ModelPromptPreparationOutcome> = [];
		final values = optionalArrayField(verificationValue, "promptPreparationExpects");
		for (value in values) preparations.push(assertPromptPreparation(objectValue(value), hookRecordings, secretProbe));
		return preparations;
	}

	static function assertPromptPreparation(
		expectValue:Value,
		hookRecordings:Array<ModelPendingInputHookRecordingOutcome>,
		secretProbe:String
	):ModelPromptPreparationOutcome {
		final preparation = ModelPromptPreparationPolicy.prepare(new ModelPromptPreparationRequest(
			stringField(expectValue, "requestId", ""),
			pendingInputHookRecordingByRequestId(hookRecordings, stringField(expectValue, "hookRecordingRequestId", "")),
			intField(expectValue, "historyItemCount", 0),
			intField(expectValue, "imageItemCountBefore", 0),
			boolField(expectValue, "modelSupportsImages", false),
			stringField(expectValue, "windowId", ""),
			boolField(expectValue, "metadataHeaderEnabled", false),
			intField(expectValue, "nextSamplingRequestIndex", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(preparation.ok));
		assertEquals(stringField(expectValue, "code", ""), preparation.code);
		assertEquals(stringField(expectValue, "requestId", ""), preparation.requestId);
		assertEquals(stringField(expectValue, "hookRecordingRequestId", ""), preparation.hookRecordingRequestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), preparation.decisionKind);
		assertEquals(boolText(boolField(expectValue, "promptPrepared", false)), boolText(preparation.promptPrepared));
		assertEquals(boolText(boolField(expectValue, "historyClonedForPrompt", false)), boolText(preparation.historyClonedForPrompt));
		assertEquals(boolText(boolField(expectValue, "forPromptNormalized", false)), boolText(preparation.forPromptNormalized));
		assertEquals(boolText(boolField(expectValue, "modelSupportsImages", false)), boolText(preparation.modelSupportsImages));
		assertEquals(Std.string(intField(expectValue, "imageItemCountBefore", 0)), Std.string(preparation.imageItemCountBefore));
		assertEquals(Std.string(intField(expectValue, "imageItemCountAfter", 0)), Std.string(preparation.imageItemCountAfter));
		assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(preparation.promptItemCount));
		assertEquals(Std.string(intField(expectValue, "recordedPendingInputCount", 0)), Std.string(preparation.recordedPendingInputCount));
		assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(preparation.nextSamplingRequestIndex));
		assertEquals(boolText(boolField(expectValue, "currentWindowIdRead", false)), boolText(preparation.currentWindowIdRead));
		assertEquals(stringField(expectValue, "expectedWindowId", stringField(expectValue, "windowId", "")), preparation.windowId);
		assertEquals(boolText(boolField(expectValue, "turnMetadataHeaderPresent", false)), boolText(preparation.turnMetadataHeaderPresent));
		assertEquals(boolText(boolField(expectValue, "dispatchPreconditionsMet", false)), boolText(preparation.dispatchPreconditionsMet));
		assertEquals(boolText(boolField(expectValue, "breakBeforePrompt", false)), boolText(preparation.breakBeforePrompt));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(preparation.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(preparation.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(preparation.toolExecutedOutsideFixture));
		assertContains(preparation.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(preparation.summary(), secretProbe);
		return preparation;
	}

	static function assertTopLevelTerminalStopHooks(
		testCase:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		promptPreparations:Array<ModelPromptPreparationOutcome>,
		secretProbe:String
	):Array<ModelTerminalStopHookOutcome> {
		final outcomes:Array<ModelTerminalStopHookOutcome> = [];
		final values = optionalArrayField(testCase, "terminalStopHookExpects");
		for (value in values) outcomes.push(assertTerminalStopHook(objectValue(value), integrations, promptPreparations, secretProbe));
		return outcomes;
	}

	static function assertTerminalStopHooks(
		verificationValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		promptPreparations:Array<ModelPromptPreparationOutcome>,
		secretProbe:String
	):Array<ModelTerminalStopHookOutcome> {
		final outcomes:Array<ModelTerminalStopHookOutcome> = [];
		final values = optionalArrayField(verificationValue, "terminalStopHookExpects");
		for (value in values) outcomes.push(assertTerminalStopHook(objectValue(value), integrations, promptPreparations, secretProbe));
		return outcomes;
	}

	static function assertTerminalStopHook(
		expectValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		promptPreparations:Array<ModelPromptPreparationOutcome>,
		secretProbe:String
	):ModelTerminalStopHookOutcome {
		final promptPrepId = stringField(expectValue, "promptPreparationRequestId", "");
		final outcome = ModelTerminalStopHookPolicy.run(new ModelTerminalStopHookRequest(
			stringField(expectValue, "requestId", ""),
			samplingResultIntegrationByRequestId(integrations, stringField(expectValue, "integrationRequestId", "")),
			promptPrepId.length == 0 ? null : promptPreparationByRequestId(promptPreparations, promptPrepId),
			terminalStopHookTargetKind(stringField(expectValue, "targetKind", "stop")),
			intField(expectValue, "previewRunCount", 0),
			intField(expectValue, "completedRunCount", 0),
			terminalStopHookRunStatusKind(stringField(expectValue, "completedRunStatusKind", "completed")),
			boolField(expectValue, "shouldBlock", false),
			intField(expectValue, "continuationFragmentCount", 0),
			boolField(expectValue, "continuationPromptRenderable", false),
			boolField(expectValue, "shouldStop", false),
			boolField(expectValue, "legacyAfterAgentEnabled", false),
			boolField(expectValue, "legacyAfterAgentAbort", false),
			boolField(expectValue, "stopHookAlreadyActive", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(stringField(expectValue, "integrationRequestId", ""), outcome.integrationRequestId);
		assertEquals(promptPrepId, outcome.promptPreparationRequestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), outcome.decisionKind);
		assertEquals(stringField(expectValue, "targetKind", ""), outcome.targetKind);
		assertEquals(boolText(boolField(expectValue, "stopHooksEligible", false)), boolText(outcome.stopHooksEligible));
		assertEquals(boolText(boolField(expectValue, "stopHookDispatched", false)), boolText(outcome.stopHookDispatched));
		assertEquals(boolText(boolField(expectValue, "stopHookAlreadyActive", false)), boolText(outcome.stopHookAlreadyActive));
		assertEquals(Std.string(intField(expectValue, "previewRunCount", 0)), Std.string(outcome.previewRunCount));
		assertEquals(Std.string(intField(expectValue, "completedRunCount", 0)), Std.string(outcome.completedRunCount));
		assertEquals(stringField(expectValue, "completedRunStatusKind", ""), outcome.completedRunStatusKind);
		assertEquals(Std.string(intField(expectValue, "hookStartedEventsProjected", 0)), Std.string(outcome.hookStartedEventsProjected));
		assertEquals(Std.string(intField(expectValue, "hookCompletedEventsProjected", 0)), Std.string(outcome.hookCompletedEventsProjected));
		assertEquals(boolText(boolField(expectValue, "shouldBlock", false)), boolText(outcome.shouldBlock));
		assertEquals(Std.string(intField(expectValue, "continuationFragmentCount", 0)), Std.string(outcome.continuationFragmentCount));
		assertEquals(boolText(boolField(expectValue, "continuationPromptRecorded", false)), boolText(outcome.continuationPromptRecorded));
		assertEquals(boolText(boolField(expectValue, "warningEmitted", false)), boolText(outcome.warningEmitted));
		assertEquals(boolText(boolField(expectValue, "shouldStop", false)), boolText(outcome.shouldStop));
		assertEquals(boolText(boolField(expectValue, "legacyAfterAgentRan", false)), boolText(outcome.legacyAfterAgentRan));
		assertEquals(boolText(boolField(expectValue, "legacyAfterAgentAbort", false)), boolText(outcome.legacyAfterAgentAbort));
		assertEquals(stringField(expectValue, "lastAgentMessage", ""), outcome.lastAgentMessage);
		assertEquals(boolText(boolField(expectValue, "continueLoop", false)), boolText(outcome.continueLoop));
		assertEquals(boolText(boolField(expectValue, "breakTurnLoop", false)), boolText(outcome.breakTurnLoop));
		assertEquals(boolText(boolField(expectValue, "errorEmitted", false)), boolText(outcome.errorEmitted));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function samplingResultIntegrationByRequestId(integrations:Array<ModelSamplingResultIntegrationOutcome>, requestId:String):ModelSamplingResultIntegrationOutcome {
		for (integration in integrations) if (integration.requestId == requestId) return integration;
		throw "missing sampling result integration outcome: " + requestId;
	}

	static function promptPreparationByRequestId(
		preparations:Array<ModelPromptPreparationOutcome>,
		requestId:String
	):ModelPromptPreparationOutcome {
		for (preparation in preparations) if (preparation.requestId == requestId) return preparation;
		throw "missing prompt preparation outcome: " + requestId;
	}

	static function pendingInputHookRecordingByRequestId(
		recordings:Array<ModelPendingInputHookRecordingOutcome>,
		requestId:String
	):ModelPendingInputHookRecordingOutcome {
		for (recording in recordings) if (recording.requestId == requestId) return recording;
		throw "missing pending input hook recording outcome: " + requestId;
	}

	static function postSamplingPendingInputDrainByRequestId(drains:Array<ModelPostSamplingPendingInputDrainOutcome>, requestId:String):ModelPostSamplingPendingInputDrainOutcome {
		for (drain in drains) if (drain.requestId == requestId) return drain;
		throw "missing post-sampling pending input drain outcome: " + requestId;
	}

	static function postDrainEmissionByRequestId(emissions:Array<ModelPostDrainEmissionOutcome>, requestId:String):ModelPostDrainEmissionOutcome {
		for (emission in emissions) if (emission.requestId == requestId) return emission;
		throw "missing post-drain emission outcome: " + requestId;
	}

	static function samplingResultStatusKind(value:String):ModelSamplingResultIntegrationStatusKind {
		return switch value {
			case "ok": ModelSamplingResultIntegrationStatusKind.Ok;
			case "cancelled": ModelSamplingResultIntegrationStatusKind.Cancelled;
			case "error": ModelSamplingResultIntegrationStatusKind.Error;
			case _: throw "unknown sampling result integration status kind: " + value;
		}
	}

	static function streamHandoffByRequestId(handoffs:Array<ModelSamplingStreamEventHandoffOutcome>, requestId:String):ModelSamplingStreamEventHandoffOutcome {
		for (handoff in handoffs) if (handoff.requestId == requestId) return handoff;
		throw "missing stream handoff outcome: " + requestId;
	}

	static function inFlightDrainItems(values:Array<Value>):Array<ModelInFlightToolDrainItem> {
		final out:Array<ModelInFlightToolDrainItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelInFlightToolDrainItem(
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				intField(item, "orderIndex", 0),
				stringField(item, "outputText", ""),
				boolField(item, "success", false),
				inFlightFailureKind(stringField(item, "failureKind", "none")),
				boolField(item, "fromResponseInput", false),
				boolField(item, "externalContext", false)
			));
		}
		return out;
	}

	static function inFlightFailureKind(value:String):ModelInFlightToolDrainFailureKind {
		return switch value {
			case "none": ModelInFlightToolDrainFailureKind.None;
			case "converted_tool_failure": ModelInFlightToolDrainFailureKind.ConvertedToolFailure;
			case "fatal_tool_future": ModelInFlightToolDrainFailureKind.FatalToolFuture;
			case _: throw "unknown in-flight tool drain failure kind: " + value;
		}
	}

	static function samplingStreamErrorKind(value:String):ModelSamplingStreamErrorKind {
		return switch value {
			case "none": ModelSamplingStreamErrorKind.None;
			case "stream_disconnected": ModelSamplingStreamErrorKind.StreamDisconnected;
			case "unauthorized": ModelSamplingStreamErrorKind.Unauthorized;
			case "context_window_exceeded": ModelSamplingStreamErrorKind.ContextWindowExceeded;
			case "usage_limit_reached": ModelSamplingStreamErrorKind.UsageLimitReached;
			case "non_retryable_api_error": ModelSamplingStreamErrorKind.NonRetryableApiError;
			case _: throw "unknown sampling stream error kind: " + value;
		}
	}

	static function samplingDispatchTransportKind(value:String):ModelSamplingDispatchTransportKind {
		return switch value {
			case "responses_http": ModelSamplingDispatchTransportKind.ResponsesHttp;
			case "responses_websocket": ModelSamplingDispatchTransportKind.ResponsesWebsocket;
			case "fixture_disabled": ModelSamplingDispatchTransportKind.FixtureDisabled;
			case _: throw "unknown sampling dispatch transport kind: " + value;
		}
	}

	static function samplingInputItems(values:Array<Value>):Array<ModelSamplingInputItem> {
		final out:Array<ModelSamplingInputItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelSamplingInputItem(
				samplingInputItemKind(stringField(item, "kind", "")),
				intField(item, "orderIndex", 0),
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				stringField(item, "text", ""),
				boolField(item, "fromPendingInput", false),
				boolField(item, "recordedInHistory", false)
			));
		}
		return out;
	}

	static function postSamplingPendingInputItems(values:Array<Value>):Array<ModelPostSamplingPendingInputDrainItem> {
		final out:Array<ModelPostSamplingPendingInputDrainItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelPostSamplingPendingInputDrainItem(
				postSamplingPendingInputSourceKind(stringField(item, "sourceKind", "active_turn")),
				samplingInputItemKind(stringField(item, "inputKind", "pending_user_input")),
				intField(item, "orderIndex", 0),
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				stringField(item, "text", "")
			));
		}
		return out;
	}

	static function pendingInputHookRecordingItems(values:Array<Value>):Array<ModelPendingInputHookRecordingItem> {
		final out:Array<ModelPendingInputHookRecordingItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelPendingInputHookRecordingItem(
				postSamplingPendingInputSourceKind(stringField(item, "sourceKind", "active_turn")),
				samplingInputItemKind(stringField(item, "inputKind", "pending_user_input")),
				intField(item, "orderIndex", 0),
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				stringField(item, "text", ""),
				pendingInputHookActionKind(stringField(item, "hookActionKind", "continue_input")),
				intField(item, "additionalContextCount", 0)
			));
		}
		return out;
	}

	static function pendingInputHookActionKind(value:String):ModelPendingInputHookActionKind {
		return switch value {
			case "continue_input": ModelPendingInputHookActionKind.ContinueInput;
			case "stop_input": ModelPendingInputHookActionKind.StopInput;
			case _: throw "unknown pending input hook action kind: " + value;
		}
	}

	static function terminalStopHookTargetKind(value:String):ModelTerminalStopHookTargetKind {
		return switch value {
			case "stop": ModelTerminalStopHookTargetKind.Stop;
			case "subagent_stop": ModelTerminalStopHookTargetKind.SubagentStop;
			case "internal_subagent_skip": ModelTerminalStopHookTargetKind.InternalSubagentSkip;
			case _: throw "unknown terminal stop hook target kind: " + value;
		}
	}

	static function terminalStopHookRunStatusKind(value:String):ModelTerminalStopHookRunStatusKind {
		return switch value {
			case "running": ModelTerminalStopHookRunStatusKind.Running;
			case "completed": ModelTerminalStopHookRunStatusKind.Completed;
			case "failed": ModelTerminalStopHookRunStatusKind.Failed;
			case "blocked": ModelTerminalStopHookRunStatusKind.Blocked;
			case "stopped": ModelTerminalStopHookRunStatusKind.Stopped;
			case _: throw "unknown terminal stop hook run status kind: " + value;
		}
	}

	static function postSamplingPendingInputSourceKind(value:String):ModelPostSamplingPendingInputSourceKind {
		return switch value {
			case "active_turn": ModelPostSamplingPendingInputSourceKind.ActiveTurn;
			case "mailbox": ModelPostSamplingPendingInputSourceKind.Mailbox;
			case _: throw "unknown post-sampling pending input source kind: " + value;
		}
	}

	static function samplingInputItemKind(value:String):ModelSamplingInputItemKind {
		return switch value {
			case "tool_response_output": ModelSamplingInputItemKind.ToolResponseOutput;
			case "pending_user_input": ModelSamplingInputItemKind.PendingUserInput;
			case "pending_response_item": ModelSamplingInputItemKind.PendingResponseItem;
			case _: throw "unknown sampling input item kind: " + value;
		}
	}

	static function toolOutputItemKind(value:String):ModelPatchToolOutputItemKind {
		return switch value {
			case "custom_tool_call_output": ModelPatchToolOutputItemKind.CustomToolCallOutput;
			case "function_call_output": ModelPatchToolOutputItemKind.FunctionCallOutput;
			case _: throw "unknown tool output item kind: " + value;
		}
	}

	static function virtualFiles(values:Array<Value>):Array<ModelPatchVirtualFile> {
		final out:Array<ModelPatchVirtualFile> = [];
		for (value in values) {
			final file = objectValue(value);
			out.push(new ModelPatchVirtualFile(stringField(file, "path", ""), stringField(file, "content", "")));
		}
		return out;
	}

	static function patchApplyStatus(value:String):ModelPatchApplyStatus {
		return switch value {
			case "completed": ModelPatchApplyStatus.Completed;
			case "failed": ModelPatchApplyStatus.Failed;
			case "declined": ModelPatchApplyStatus.Declined;
			case _: throw "invalid patch apply status: " + value;
		}
	}

	static function approvalRequirement(value:String):ModelPatchApprovalRequirement {
		return switch value {
			case "skip": ModelPatchApprovalRequirement.Skip;
			case "needs_approval": ModelPatchApprovalRequirement.NeedsApproval;
			case _: throw "invalid patch approval requirement: " + value;
		}
	}

	static function reviewDecision(value:String):ModelPatchReviewDecision {
		return switch value {
			case "approved": ModelPatchReviewDecision.Approved;
			case "approved_for_session": ModelPatchReviewDecision.ApprovedForSession;
			case "approved_with_amendment": ModelPatchReviewDecision.ApprovedWithAmendment;
			case "denied": ModelPatchReviewDecision.Denied;
			case "timed_out": ModelPatchReviewDecision.TimedOut;
			case "abort": ModelPatchReviewDecision.Abort;
			case _: throw "invalid patch review decision: " + value;
		}
	}

	static function sandboxAttempt(value:String):ModelPatchSandboxAttemptKind {
		return switch value {
			case "none": ModelPatchSandboxAttemptKind.None;
			case "sandboxed": ModelPatchSandboxAttemptKind.Sandboxed;
			case "escalated": ModelPatchSandboxAttemptKind.Escalated;
			case _: throw "invalid patch sandbox attempt: " + value;
		}
	}

	static function toolEventStage(value:String):ModelPatchToolEventStageKind {
		return switch value {
			case "success": ModelPatchToolEventStageKind.Success;
			case "failure_output": ModelPatchToolEventStageKind.FailureOutput;
			case "failure_message": ModelPatchToolEventStageKind.FailureMessage;
			case "rejected": ModelPatchToolEventStageKind.Rejected;
			case _: throw "invalid patch tool event stage: " + value;
		}
	}

	static function fixtureRoot(path:String):Value {
		return expectParse(CodexJson.parse(File.getContent(path)));
	}

	static function objectField(object:Value, name:String):Value {
		return objectValue(valueField(object, name));
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function optionalArrayField(object:Value, name:String):Array<Value> {
		return switch optionalField(object, name) {
			case JArray(values): values;
			case JNull: [];
			case _: throw "expected array field: " + name;
		}
	}

	static function stringArrayField(object:Value, name:String):Array<String> {
		final out:Array<String> = [];
		return switch optionalField(object, name) {
			case JArray(values):
				for (value in values) {
					switch value {
						case JString(text): out.push(text);
						case _: throw "expected string array field: " + name;
					}
				}
				out;
			case JNull:
				out;
			case _:
				throw "expected string array field: " + name;
		}
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		return switch optionalField(object, name) {
			case JString(value): value;
			case JNull: fallback;
			case _: throw "expected string field: " + name;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		return switch optionalField(object, name) {
			case JNumber(value): Std.int(value);
			case JNull: fallback;
			case _: throw "expected int field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		return switch optionalField(object, name) {
			case JBool(value): value;
			case JNull: fallback;
			case _: throw "expected bool field: " + name;
		}
	}

	static function valueField(object:Value, name:String):Value {
		return optionalField(object, name);
	}

	static function optionalField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) return values[i];
					i = i + 1;
				}
				JNull;
			case _:
				throw "expected object while reading field: " + name;
		}
	}

	static function objectValue(value:Value):Value {
		return switch value {
			case JObject(_, _): value;
			case _: throw "expected object";
		}
	}

	static function expectParse(outcome:JsonParseOutcome):Value {
		if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function assertContains(value:String, needle:String):Void {
		if (needle.length == 0) return;
		if (value.indexOf(needle) < 0) throw "expected to find `" + needle + "` in `" + value + "`";
	}

	static function assertNotContains(value:String, needle:String):Void {
		if (value.indexOf(needle) >= 0) throw "expected not to find `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual) throw "expected `" + expected + "` but got `" + actual + "`";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
