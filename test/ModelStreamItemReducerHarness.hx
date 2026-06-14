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
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpPolicy;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpRequest;
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
				assertPatchToolFollowUp(verificationValue, outcome, application, projection, secretProbe);
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
	):Void {
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
			case JNull:
			case _:
				throw "expected object field: toolFollowUpExpect";
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
