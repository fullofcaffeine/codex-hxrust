package codexhx.runtime.model.streamitem;

class ModelKeymapMainSurfaceAssignmentPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapMainSurfaceAssignmentRequest):ModelKeymapMainSurfaceAssignmentOutcome {
		if (request == null)
			return failure("", "missing keymap main-surface assignment request");

		final expectedBinding = character("f", true, false, true);
		final actionKindPreserved = request.actionKind == ModelKeymapMainSurfaceAssignmentActionKind.ToggleFastMode;
		final defaultBindingEmptyPreserved = request.defaultBindings.length == 0;
		final configuredBindingPreserved = matches(request.configuredBinding, expectedBinding);
		final runtimeBindingPreserved = matches(request.runtimeBinding, expectedBinding);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = actionKindPreserved && defaultBindingEmptyPreserved && configuredBindingPreserved && runtimeBindingPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapMainSurfaceAssignmentDecisionKind.KeymapMainSurfaceAssignmentPreserved : ModelKeymapMainSurfaceAssignmentDecisionKind.KeymapMainSurfaceAssignmentRejected;

		return new ModelKeymapMainSurfaceAssignmentOutcome({
			ok: ok,
			code: ok ? "keymap_main_surface_assignment_modeled" : "keymap_main_surface_assignment_unmet",
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
			errorMessage: ok ? "" : "keymap main-surface assignment did not match upstream expectations"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapMainSurfaceAssignmentOutcome {
		return new ModelKeymapMainSurfaceAssignmentOutcome({
			ok: false,
			code: "keymap_main_surface_assignment_failed",
			requestId: requestId,
			decisionKind: ModelKeymapMainSurfaceAssignmentDecisionKind.KeymapMainSurfaceAssignmentRejected,
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
