package codexhx.runtime.model.streamitem;

class ModelKeymapApprovalConflictPolicy {
	static final NoFunctionNumber = -1;
	static final ApproveName = "approve";
	static final DeclineName = "decline";

	public static function apply(request:ModelKeymapApprovalConflictRequest):ModelKeymapApprovalConflictOutcome {
		if (request == null) return failure("", "missing keymap approval conflict request");

		final expectedBinding = character("y");
		final approveBindingPreserved = matches(request.configuredApprove, expectedBinding);
		final declineBindingPreserved = matches(request.configuredDecline, expectedBinding);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapApprovalConflictActionKind.ApprovalApprove
			&& request.conflictInnerAction == ModelKeymapApprovalConflictActionKind.ApprovalDecline
			&& request.expectedOuterActionName == ApproveName
			&& request.expectedInnerActionName == DeclineName;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = approveBindingPreserved
			&& declineBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictRejected
			: ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictMissed;

		return new ModelKeymapApprovalConflictOutcome({
			ok: ok,
			code: ok ? "keymap_approval_conflict_modeled" : "keymap_approval_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			approveBindingPreserved: approveBindingPreserved,
			declineBindingPreserved: declineBindingPreserved,
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
