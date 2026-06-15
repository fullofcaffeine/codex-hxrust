package codexhx.runtime.model.streamitem;

class ModelKeymapListConflictPolicy {
	static final NoFunctionNumber = -1;
	static final MoveUpName = "move_up";
	static final MoveDownName = "move_down";

	public static function apply(request:ModelKeymapListConflictRequest):ModelKeymapListConflictOutcome {
		if (request == null) return failure("", "missing keymap list conflict request");

		final expectedBinding = named("up");
		final moveUpBindingPreserved = matches(request.configuredMoveUp, expectedBinding);
		final moveDownBindingPreserved = matches(request.configuredMoveDown, expectedBinding);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapListConflictActionKind.ListMoveUp
			&& request.conflictInnerAction == ModelKeymapListConflictActionKind.ListMoveDown
			&& request.expectedOuterActionName == MoveUpName
			&& request.expectedInnerActionName == MoveDownName;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = moveUpBindingPreserved
			&& moveDownBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapListConflictDecisionKind.KeymapListConflictRejected
			: ModelKeymapListConflictDecisionKind.KeymapListConflictMissed;

		return new ModelKeymapListConflictOutcome({
			ok: ok,
			code: ok ? "keymap_list_conflict_modeled" : "keymap_list_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			moveUpBindingPreserved: moveUpBindingPreserved,
			moveDownBindingPreserved: moveDownBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap list conflict did not match upstream expectations"
		});
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapListConflictOutcome {
		return new ModelKeymapListConflictOutcome({
			ok: false,
			code: "keymap_list_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapListConflictDecisionKind.KeymapListConflictMissed,
			moveUpBindingPreserved: false,
			moveDownBindingPreserved: false,
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
