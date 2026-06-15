package codexhx.runtime.model.streamitem;

class ModelKeymapListConflictPolicy {
	static final NoFunctionNumber = -1;
	static final MoveUpName = "move_up";
	static final MoveDownName = "move_down";
	static final MoveLeftName = "move_left";
	static final MoveRightName = "move_right";

	public static function apply(request:ModelKeymapListConflictRequest):ModelKeymapListConflictOutcome {
		if (request == null) return failure("", "missing keymap list conflict request");

		final conflictKind = conflictKind(request);
		final expectedBinding = expectedBindingFor(conflictKind);
		final outerBindingPreserved = matches(request.configuredOuterBinding, expectedBinding);
		final innerBindingPreserved = matches(request.configuredInnerBinding, expectedBinding);
		final conflictActionNamesPreserved = conflictKind != ModelKeymapListConflictKind.Unknown;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = outerBindingPreserved
			&& innerBindingPreserved
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
			outerBindingPreserved: outerBindingPreserved,
			innerBindingPreserved: innerBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap list conflict did not match upstream expectations"
		});
	}

	static function conflictKind(request:ModelKeymapListConflictRequest):ModelKeymapListConflictKind {
		if (request.conflictOuterAction == ModelKeymapListConflictActionKind.ListMoveUp
			&& request.conflictInnerAction == ModelKeymapListConflictActionKind.ListMoveDown
			&& request.expectedOuterActionName == MoveUpName
			&& request.expectedInnerActionName == MoveDownName) {
			return ModelKeymapListConflictKind.Vertical;
		}
		if (request.conflictOuterAction == ModelKeymapListConflictActionKind.ListMoveLeft
			&& request.conflictInnerAction == ModelKeymapListConflictActionKind.ListMoveRight
			&& request.expectedOuterActionName == MoveLeftName
			&& request.expectedInnerActionName == MoveRightName) {
			return ModelKeymapListConflictKind.Horizontal;
		}
		return ModelKeymapListConflictKind.Unknown;
	}

	static function expectedBindingFor(kind:ModelKeymapListConflictKind):ModelKeymapBinding {
		return switch kind {
			case Vertical: named("up");
			case Horizontal: named("left");
			case Unknown: named("");
		}
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
			outerBindingPreserved: false,
			innerBindingPreserved: false,
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

private enum ModelKeymapListConflictKind {
	Vertical;
	Horizontal;
	Unknown;
}
