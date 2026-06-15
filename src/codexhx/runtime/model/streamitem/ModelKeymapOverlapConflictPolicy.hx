package codexhx.runtime.model.streamitem;

class ModelKeymapOverlapConflictPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapOverlapConflictRequest):ModelKeymapOverlapConflictOutcome {
		if (request == null) return failure("", "missing keymap overlap conflict request");

		final explicitListLegacyConflictPreserved = conflict(
			request.explicitListLegacyOuterAction,
			ModelKeymapOverlapConflictActionKind.ListMoveUp,
			request.explicitListLegacyInnerAction,
			ModelKeymapOverlapConflictActionKind.ListPageUp,
			request.explicitListLegacyBinding,
			named("page-up")
		);
		final appBindingPrunesListDefaultPreserved = matches(request.configuredAppCopy, named("page-down"))
			&& sameBindings(request.prunedListPageDownAfterApp, [character("f", true)]);
		final approvalBindingPrunesListDefaultPreserved = matches(request.configuredApprovalApprove, named("home"))
			&& sameBindings(request.prunedListJumpTopAfterApproval, []);
		final explicitListApprovalConflictPreserved = conflict(
			request.explicitListApprovalOuterAction,
			ModelKeymapOverlapConflictActionKind.ListJumpTop,
			request.explicitListApprovalInnerAction,
			ModelKeymapOverlapConflictActionKind.ApprovalApprove,
			request.explicitListApprovalBinding,
			named("home")
		);
		final legacyVimChangePruningPreserved = matches(request.configuredLegacyVimMoveLeftForChange, character("c", false))
			&& sameBindings(request.prunedVimStartChangeOperator, []);
		final explicitVimChangeConflictPreserved = conflict(
			request.explicitVimChangeOuterAction,
			ModelKeymapOverlapConflictActionKind.VimNormalMoveLeft,
			request.explicitVimChangeInnerAction,
			ModelKeymapOverlapConflictActionKind.VimNormalStartChangeOperator,
			request.explicitVimChangeBinding,
			character("c", false)
		);
		final legacyVimSubstitutePruningPreserved = matches(request.configuredLegacyVimMoveLeftForSubstitute, character("s", false))
			&& sameBindings(request.prunedVimSubstituteChar, []);
		final explicitVimSubstituteConflictPreserved = conflict(
			request.explicitVimSubstituteOuterAction,
			ModelKeymapOverlapConflictActionKind.VimNormalMoveLeft,
			request.explicitVimSubstituteInnerAction,
			ModelKeymapOverlapConflictActionKind.VimNormalSubstituteChar,
			request.explicitVimSubstituteBinding,
			character("s", false)
		);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = explicitListLegacyConflictPreserved
			&& appBindingPrunesListDefaultPreserved
			&& approvalBindingPrunesListDefaultPreserved
			&& explicitListApprovalConflictPreserved
			&& legacyVimChangePruningPreserved
			&& explicitVimChangeConflictPreserved
			&& legacyVimSubstitutePruningPreserved
			&& explicitVimSubstituteConflictPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapOverlapConflictDecisionKind.KeymapOverlapConflictsPreserved
			: ModelKeymapOverlapConflictDecisionKind.KeymapOverlapConflictsRejected;

		return new ModelKeymapOverlapConflictOutcome({
			ok: ok,
			code: ok ? "keymap_overlap_conflicts_modeled" : "keymap_overlap_conflicts_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			explicitListLegacyConflictPreserved: explicitListLegacyConflictPreserved,
			appBindingPrunesListDefaultPreserved: appBindingPrunesListDefaultPreserved,
			approvalBindingPrunesListDefaultPreserved: approvalBindingPrunesListDefaultPreserved,
			explicitListApprovalConflictPreserved: explicitListApprovalConflictPreserved,
			legacyVimChangePruningPreserved: legacyVimChangePruningPreserved,
			explicitVimChangeConflictPreserved: explicitVimChangeConflictPreserved,
			legacyVimSubstitutePruningPreserved: legacyVimSubstitutePruningPreserved,
			explicitVimSubstituteConflictPreserved: explicitVimSubstituteConflictPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap overlap conflicts did not match upstream expectations"
		});
	}

	static function conflict(
		actualOuter:ModelKeymapOverlapConflictActionKind,
		expectedOuter:ModelKeymapOverlapConflictActionKind,
		actualInner:ModelKeymapOverlapConflictActionKind,
		expectedInner:ModelKeymapOverlapConflictActionKind,
		actualBinding:Null<ModelKeymapBinding>,
		expectedBinding:ModelKeymapBinding
	):Bool {
		return actualOuter == expectedOuter && actualInner == expectedInner && matches(actualBinding, expectedBinding);
	}

	static function sameBindings(actual:Array<ModelKeymapBinding>, expected:Array<ModelKeymapBinding>):Bool {
		if (actual.length != expected.length) return false;
		for (i in 0...actual.length) {
			if (!matches(actual[i], expected[i])) return false;
		}
		return true;
	}

	static function matches(actual:Null<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		return actual != null && actual.equals(expected);
	}

	static function named(keyName:String):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Named,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: false,
			altModifier: false,
			shiftModifier: false
		});
	}

	static function character(keyName:String, ctrlModifier:Bool):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Character,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: ctrlModifier,
			altModifier: false,
			shiftModifier: false
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelKeymapOverlapConflictOutcome {
		return new ModelKeymapOverlapConflictOutcome({
			ok: false,
			code: "keymap_overlap_conflicts_failed",
			requestId: requestId,
			decisionKind: ModelKeymapOverlapConflictDecisionKind.KeymapOverlapConflictsRejected,
			explicitListLegacyConflictPreserved: false,
			appBindingPrunesListDefaultPreserved: false,
			approvalBindingPrunesListDefaultPreserved: false,
			explicitListApprovalConflictPreserved: false,
			legacyVimChangePruningPreserved: false,
			explicitVimChangeConflictPreserved: false,
			legacyVimSubstitutePruningPreserved: false,
			explicitVimSubstituteConflictPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
