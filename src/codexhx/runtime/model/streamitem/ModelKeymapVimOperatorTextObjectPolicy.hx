package codexhx.runtime.model.streamitem;

class ModelKeymapVimOperatorTextObjectPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapVimOperatorTextObjectRequest):ModelKeymapVimOperatorTextObjectOutcome {
		if (request == null)
			return failure("", "missing keymap vim-operator text-object request");

		final legacyMotionPruningPreserved = matches(request.configuredMotionLeft, character("i"))
			&& matches(request.configuredMotionRight, character("a"))
			&& sameBindings(request.prunedSelectInnerTextObject, [])
			&& sameBindings(request.prunedSelectAroundTextObject, []);
		final explicitTextObjectConflictPreserved = request.explicitConflictOuterAction == ModelKeymapVimOperatorTextObjectActionKind.VimOperatorMotionLeft
			&& request.explicitConflictInnerAction == ModelKeymapVimOperatorTextObjectActionKind.VimOperatorSelectInnerTextObject
			&& matches(request.explicitConflictBinding, character("i"));
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = legacyMotionPruningPreserved && explicitTextObjectConflictPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapVimOperatorTextObjectDecisionKind.KeymapVimOperatorTextObjectsPreserved : ModelKeymapVimOperatorTextObjectDecisionKind.KeymapVimOperatorTextObjectsRejected;

		return new ModelKeymapVimOperatorTextObjectOutcome({
			ok: ok,
			code: ok ? "keymap_vim_operator_text_objects_modeled" : "keymap_vim_operator_text_objects_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			legacyMotionPruningPreserved: legacyMotionPruningPreserved,
			explicitTextObjectConflictPreserved: explicitTextObjectConflictPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap vim-operator text-object expectations were not satisfied"
		});
	}

	static function sameBindings(actual:Array<ModelKeymapBinding>, expected:Array<ModelKeymapBinding>):Bool {
		if (actual.length != expected.length)
			return false;
		for (i in 0...actual.length) {
			if (!matches(actual[i], expected[i]))
				return false;
		}
		return true;
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapVimOperatorTextObjectOutcome {
		return new ModelKeymapVimOperatorTextObjectOutcome({
			ok: false,
			code: "keymap_vim_operator_text_objects_failed",
			requestId: requestId,
			decisionKind: ModelKeymapVimOperatorTextObjectDecisionKind.KeymapVimOperatorTextObjectsRejected,
			legacyMotionPruningPreserved: false,
			explicitTextObjectConflictPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
