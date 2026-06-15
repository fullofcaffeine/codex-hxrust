package codexhx.runtime.model.streamitem;

class ModelKeymapPagerConflictPolicy {
	static final NoFunctionNumber = -1;
	static final ScrollUpName = "scroll_up";
	static final ScrollDownName = "scroll_down";

	public static function apply(request:ModelKeymapPagerConflictRequest):ModelKeymapPagerConflictOutcome {
		if (request == null) return failure("", "missing keymap pager conflict request");

		final expectedBinding = character("u", true);
		final scrollUpBindingPreserved = matches(request.configuredScrollUp, expectedBinding);
		final scrollDownBindingPreserved = matches(request.configuredScrollDown, expectedBinding);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapPagerConflictActionKind.PagerScrollUp
			&& request.conflictInnerAction == ModelKeymapPagerConflictActionKind.PagerScrollDown
			&& request.expectedOuterActionName == ScrollUpName
			&& request.expectedInnerActionName == ScrollDownName;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = scrollUpBindingPreserved
			&& scrollDownBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapPagerConflictDecisionKind.KeymapPagerConflictRejected
			: ModelKeymapPagerConflictDecisionKind.KeymapPagerConflictMissed;

		return new ModelKeymapPagerConflictOutcome({
			ok: ok,
			code: ok ? "keymap_pager_conflict_modeled" : "keymap_pager_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			scrollUpBindingPreserved: scrollUpBindingPreserved,
			scrollDownBindingPreserved: scrollDownBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap pager conflict did not match upstream expectations"
		});
	}

	static function matches(actual:Null<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		return actual != null && actual.equals(expected);
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapPagerConflictOutcome {
		return new ModelKeymapPagerConflictOutcome({
			ok: false,
			code: "keymap_pager_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapPagerConflictDecisionKind.KeymapPagerConflictMissed,
			scrollUpBindingPreserved: false,
			scrollDownBindingPreserved: false,
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
