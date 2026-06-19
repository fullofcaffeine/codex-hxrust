package codexhx.runtime.model.streamitem;

class ModelKeymapApprovalConflictPolicy {
	static final NoFunctionNumber = -1;
	static final ApproveName = "approve";
	static final DeclineName = "decline";
	static final DenyName = "deny";
	static final ListAcceptName = "list.accept";
	static final ListCancelName = "list.cancel";
	static final ApprovalApproveName = "approval.approve";
	static final ApprovalCancelName = "approval.cancel";

	public static function apply(request:ModelKeymapApprovalConflictRequest):ModelKeymapApprovalConflictOutcome {
		if (request == null)
			return failure("", "missing keymap approval conflict request");

		final approvalBinding = character("y");
		final cancelBinding = character("c");
		final approveBindingPreserved = matches(request.configuredApprove, approvalBinding);
		final declineBindingPreserved = matches(request.configuredDecline, approvalBinding);
		final denyBindingPreserved = matches(request.configuredDeny, approvalBinding);
		final listAcceptBindingPreserved = matches(request.configuredListAccept, approvalBinding);
		final listCancelBindingPreserved = matches(request.configuredListCancel, cancelBinding);
		final declineConflictPreserved = request.conflictInnerAction == ModelKeymapApprovalConflictActionKind.ApprovalDecline
			&& request.expectedInnerActionName == DeclineName
			&& declineBindingPreserved;
		final denyConflictPreserved = request.conflictInnerAction == ModelKeymapApprovalConflictActionKind.ApprovalDeny
			&& request.expectedInnerActionName == DenyName
			&& denyBindingPreserved;
		final approvalPairConflictPreserved = request.conflictOuterAction == ModelKeymapApprovalConflictActionKind.ApprovalApprove
			&& request.expectedOuterActionName == ApproveName
			&& (declineConflictPreserved || denyConflictPreserved);
		final overlayAcceptConflictPreserved = request.conflictOuterAction == ModelKeymapApprovalConflictActionKind.ListAccept
			&& request.conflictInnerAction == ModelKeymapApprovalConflictActionKind.ApprovalApprove
			&& request.expectedOuterActionName == ListAcceptName
			&& request.expectedInnerActionName == ApprovalApproveName
			&& listAcceptBindingPreserved;
		final overlayCancelConflictPreserved = request.conflictOuterAction == ModelKeymapApprovalConflictActionKind.ListCancel
			&& request.conflictInnerAction == ModelKeymapApprovalConflictActionKind.ApprovalCancel
			&& request.expectedOuterActionName == ListCancelName
			&& request.expectedInnerActionName == ApprovalCancelName
			&& listCancelBindingPreserved;
		final conflictActionNamesPreserved = approvalPairConflictPreserved || overlayAcceptConflictPreserved || overlayCancelConflictPreserved;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final bindingEvidencePreserved = approvalPairConflictPreserved ? approveBindingPreserved : overlayAcceptConflictPreserved
			|| overlayCancelConflictPreserved;
		final ok = bindingEvidencePreserved && conflictRejectionPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictRejected : ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictMissed;

		return new ModelKeymapApprovalConflictOutcome({
			ok: ok,
			code: ok ? "keymap_approval_conflict_modeled" : "keymap_approval_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			approveBindingPreserved: approveBindingPreserved,
			declineBindingPreserved: declineBindingPreserved,
			denyBindingPreserved: denyBindingPreserved,
			listAcceptBindingPreserved: listAcceptBindingPreserved,
			listCancelBindingPreserved: listCancelBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap approval conflict did not match upstream expectations"
		});
	}

	static function matches(actual:Null<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		return actual != null && actual.equals(expected);
	}

	static function character(keyName:String):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Character,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: false,
			altModifier: false,
			shiftModifier: false
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelKeymapApprovalConflictOutcome {
		return new ModelKeymapApprovalConflictOutcome({
			ok: false,
			code: "keymap_approval_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictMissed,
			approveBindingPreserved: false,
			declineBindingPreserved: false,
			denyBindingPreserved: false,
			listAcceptBindingPreserved: false,
			listCancelBindingPreserved: false,
			conflictActionNamesPreserved: false,
			conflictRejectionPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
