package codexhx.runtime.model.streamitem;

class ModelPatchToolFollowUpPolicy {
	public static function build(request:ModelPatchToolFollowUpRequest):ModelPatchToolFollowUpOutcome {
		if (request == null) return failure("", "missing patch tool follow-up request");
		if (request.reducerOutcome == null || !request.reducerOutcome.ok) {
			return failure(request.requestId, "patch tool follow-up requires a reduced stream outcome");
		}
		if (request.applicationOutcome == null || !request.applicationOutcome.ok) {
			return failure(request.requestId, "patch tool follow-up requires a modeled application outcome");
		}
		if (request.projectionOutcome == null || !request.projectionOutcome.ok) {
			return failure(request.requestId, "patch tool follow-up requires a modeled projection outcome");
		}

		final queued = queuedApplyPatchEvent(request.reducerOutcome, request.projectionOutcome.itemId);
		if (queued == null) return failure(request.requestId, "missing queued apply_patch tool call for callId=" + request.projectionOutcome.itemId);

		final completed = request.applicationOutcome.status == ModelPatchApplyStatus.Completed;
		final stdoutVisible = request.applicationOutcome.stdout.length > 0;
		final stderrVisible = request.applicationOutcome.stderr.length > 0;
		final outputText = modelOutputText(request.applicationOutcome);
		return new ModelPatchToolFollowUpOutcome(
			true,
			"patch_tool_output_follow_up_modeled",
			request.requestId,
			queued.callId,
			responseKindFor(queued.itemKind),
			outputText,
			completed,
			true,
			request.reducerOutcome.needsFollowUp,
			completed,
			stdoutVisible,
			stderrVisible,
			outputText.length > 0,
			false,
			false,
			false,
			""
		);
	}

	static function queuedApplyPatchEvent(outcome:ModelStreamItemReducerOutcome, callId:String):ModelStreamRuntimeEvent {
		for (event in outcome.runtimeEvents) {
			if (event.kind == ModelStreamRuntimeEventKind.ToolCallQueued
				&& event.toolName == "apply_patch"
				&& event.callId == callId) return event;
		}
		return null;
	}

	static function responseKindFor(itemKind:ModelStreamOutputItemKind):ModelPatchToolOutputItemKind {
		return itemKind == ModelStreamOutputItemKind.CustomToolCall
			? ModelPatchToolOutputItemKind.CustomToolCallOutput
			: ModelPatchToolOutputItemKind.FunctionCallOutput;
	}

	static function modelOutputText(application:ModelPatchApplicationOutcome):String {
		if (application.stdout.length > 0) return application.stdout;
		if (application.stderr.length > 0) return application.stderr;
		return application.status;
	}

	static function failure(requestId:String, errorMessage:String):ModelPatchToolFollowUpOutcome {
		return new ModelPatchToolFollowUpOutcome(
			false,
			"patch_tool_output_follow_up_failed",
			requestId,
			"",
			ModelPatchToolOutputItemKind.FunctionCallOutput,
			"",
			false,
			false,
			false,
			false,
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
