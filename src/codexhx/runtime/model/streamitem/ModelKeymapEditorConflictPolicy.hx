package codexhx.runtime.model.streamitem;

class ModelKeymapEditorConflictPolicy {
	static final NoFunctionNumber = -1;
	static final MoveLeftName = "move_left";
	static final MoveRightName = "move_right";

	public static function apply(request:ModelKeymapEditorConflictRequest):ModelKeymapEditorConflictOutcome {
		if (request == null) return failure("", "missing keymap editor conflict request");

		final expectedBinding = character("h", true);
		final moveLeftBindingPreserved = matches(request.configuredMoveLeft, expectedBinding);
		final moveRightBindingPreserved = matches(request.configuredMoveRight, expectedBinding);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapEditorConflictActionKind.EditorMoveLeft
			&& request.conflictInnerAction == ModelKeymapEditorConflictActionKind.EditorMoveRight
			&& request.expectedOuterActionName == MoveLeftName
			&& request.expectedInnerActionName == MoveRightName;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = moveLeftBindingPreserved
			&& moveRightBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapEditorConflictDecisionKind.KeymapEditorConflictRejected
			: ModelKeymapEditorConflictDecisionKind.KeymapEditorConflictMissed;

		return new ModelKeymapEditorConflictOutcome({
			ok: ok,
			code: ok ? "keymap_editor_conflict_modeled" : "keymap_editor_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			moveLeftBindingPreserved: moveLeftBindingPreserved,
			moveRightBindingPreserved: moveRightBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap editor conflict did not match upstream expectations"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapEditorConflictOutcome {
		return new ModelKeymapEditorConflictOutcome({
			ok: false,
			code: "keymap_editor_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapEditorConflictDecisionKind.KeymapEditorConflictMissed,
			moveLeftBindingPreserved: false,
			moveRightBindingPreserved: false,
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
