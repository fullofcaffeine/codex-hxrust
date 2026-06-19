package codexhx.runtime.model.streamitem;

class ModelPatchApprovalDecisionPolicy {
	public static function decide(request:ModelPatchApprovalDecisionRequest):ModelPatchApprovalDecisionOutcome {
		if (request == null)
			return failure("", [], "missing patch approval decision request");
		if (request.verificationOutcome == null || !request.verificationOutcome.ok || request.verificationOutcome.endEvent == null) {
			return failure(request.requestId, [], "patch approval decision requires a verified patch outcome");
		}
		if (request.applicationOutcome == null || !request.applicationOutcome.ok) {
			return failure(request.requestId, approvalKeys(request.environmentId, request.verificationOutcome.endEvent.changes),
				"patch approval decision requires a modeled application outcome");
		}

		final keys = approvalKeys(request.environmentId, request.verificationOutcome.endEvent.changes);
		final approvalRequired = request.approvalRequirement == ModelPatchApprovalRequirement.NeedsApproval;
		final hasRetry = request.retryReason.length > 0;
		final preapproved = request.permissionsPreapproved && !hasRetry;
		final approvalRequestEmitted = approvalRequired && !preapproved;
		final effectiveDecision = preapproved ? ModelPatchReviewDecision.Approved : request.reviewDecision;
		final canRun = !approvalRequestEmitted || isApproved(effectiveDecision);
		final sandboxRetryRequested = request.sandboxDenied
			&& request.sandboxApprovalAllowed
			&& request.sandboxAttempt == ModelPatchSandboxAttemptKind.Sandboxed;
		return new ModelPatchApprovalDecisionOutcome(true, "patch_approval_decision_modeled", request.requestId, approvalRequired, approvalRequestEmitted,
			canRun, "auto", true, sandboxRetryRequested, "tool=apply_patch;input=command", effectiveDecision, keys, false, false, false, "");
	}

	static function approvalKeys(environmentId:String, changes:Array<ModelPatchFileChange>):Array<ModelPatchApprovalKey> {
		final out:Array<ModelPatchApprovalKey> = [];
		if (changes == null)
			return out;
		for (change in changes) {
			pushUnique(out, environmentId, change.path);
			if (change.kind == ModelPatchFileChangeKind.Update && change.movePath.length > 0)
				pushUnique(out, environmentId, change.movePath);
		}
		return out;
	}

	static function pushUnique(keys:Array<ModelPatchApprovalKey>, environmentId:String, path:String):Void {
		for (key in keys)
			if (key.environmentId == environmentId && key.path == path)
				return;
		keys.push(new ModelPatchApprovalKey(environmentId, path));
	}

	static function isApproved(decision:ModelPatchReviewDecision):Bool {
		return decision == ModelPatchReviewDecision.Approved
			|| decision == ModelPatchReviewDecision.ApprovedForSession
			|| decision == ModelPatchReviewDecision.ApprovedWithAmendment;
	}

	static function failure(requestId:String, keys:Array<ModelPatchApprovalKey>, errorMessage:String):ModelPatchApprovalDecisionOutcome {
		return new ModelPatchApprovalDecisionOutcome(false, "patch_approval_decision_failed", requestId, false, false, false, "auto", true, false, "",
			ModelPatchReviewDecision.Denied, keys, false, false, false, errorMessage);
	}
}
