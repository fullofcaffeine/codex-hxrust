package codexhx.runtime.model.streamitem;

class ModelKeymapEditorAssignmentPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapEditorAssignmentRequest):ModelKeymapEditorAssignmentOutcome {
		if (request == null)
			return failure("", "missing keymap editor assignment request");

		final expectedBinding = character("u", true, false, true);
		final actionKindPreserved = request.actionKind == ModelKeymapEditorAssignmentActionKind.KillWholeLine;
		final defaultBindingEmptyPreserved = request.defaultBindings.length == 0;
		final configuredBindingPreserved = matches(request.configuredBinding, expectedBinding);
		final runtimeBindingPreserved = matches(request.runtimeBinding, expectedBinding);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = actionKindPreserved && defaultBindingEmptyPreserved && configuredBindingPreserved && runtimeBindingPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapEditorAssignmentDecisionKind.KeymapEditorAssignmentPreserved : ModelKeymapEditorAssignmentDecisionKind.KeymapEditorAssignmentRejected;

		return new ModelKeymapEditorAssignmentOutcome({
			ok: ok,
			code: ok ? "keymap_editor_assignment_modeled" : "keymap_editor_assignment_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			actionKindPreserved: actionKindPreserved,
			defaultBindingEmptyPreserved: defaultBindingEmptyPreserved,
			configuredBindingPreserved: configuredBindingPreserved,
			runtimeBindingPreserved: runtimeBindingPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap editor assignment did not match upstream expectations"
		});
	}

	static function matches(actual:Null<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		return actual != null && actual.equals(expected);
	}

	static function character(keyName:String, ctrlModifier:Bool, altModifier:Bool, shiftModifier:Bool):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Character,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: ctrlModifier,
			altModifier: altModifier,
			shiftModifier: shiftModifier
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelKeymapEditorAssignmentOutcome {
		return new ModelKeymapEditorAssignmentOutcome({
			ok: false,
			code: "keymap_editor_assignment_failed",
			requestId: requestId,
			decisionKind: ModelKeymapEditorAssignmentDecisionKind.KeymapEditorAssignmentRejected,
			actionKindPreserved: false,
			defaultBindingEmptyPreserved: false,
			configuredBindingPreserved: false,
			runtimeBindingPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
