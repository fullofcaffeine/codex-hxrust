package codexhx.runtime.model.streamitem;

class ModelPatchToolResponseInputPolicy {
	public static function admit(request:ModelPatchToolResponseInputRequest):ModelPatchToolResponseInputOutcome {
		if (request == null)
			return failure("", "missing patch tool response input request");
		if (request.followUpOutcome == null || !request.followUpOutcome.ok) {
			return failure(request.requestId, "patch tool response input requires a modeled follow-up output");
		}

		final admitted = request.followUpOutcome.followUpQueued
			&& request.followUpOutcome.modelNeedsFollowUp
			&& request.followUpOutcome.resultTextVisible;
		final nextCount = admitted ? request.previousResponseCount + 1 : request.previousResponseCount;
		return new ModelPatchToolResponseInputOutcome(true, "patch_tool_response_input_admitted", request.requestId, request.followUpOutcome.callId,
			request.followUpOutcome.responseKind, admitted ? ModelPatchToolResponseAdmissionKind.Admitted : ModelPatchToolResponseAdmissionKind.Skipped,
			admitted ? nextCount : 0, nextCount, request.followUpOutcome.outputText, request.followUpOutcome.success,
			request.followUpOutcome.modelNeedsFollowUp, admitted, admitted, false, false, false, "");
	}

	static function failure(requestId:String, errorMessage:String):ModelPatchToolResponseInputOutcome {
		return new ModelPatchToolResponseInputOutcome(false, "patch_tool_response_input_failed", requestId, "",
			ModelPatchToolOutputItemKind.FunctionCallOutput, ModelPatchToolResponseAdmissionKind.Skipped, 0, 0, "", false, false, false, false, false, false,
			false, errorMessage);
	}
}
