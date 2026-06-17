package codexhx.runtime.model.streamitem;

class ModelKeymapMainSurfaceConflictPolicy {
	static final NoFunctionNumber = -1;
	static final ClearTerminalName = "clear_terminal";
	static final ToggleFastModeName = "toggle_fast_mode";

	public static function apply(request:ModelKeymapMainSurfaceConflictRequest):ModelKeymapMainSurfaceConflictOutcome {
		if (request == null) return failure("", "missing keymap main-surface conflict request");

		final ctrlL = character("l", true, false, false);
		final configuredToggleFastModeBindingPreserved = matches(request.configuredToggleFastModeBinding, ctrlL);
		final defaultClearTerminalBindingPreserved = matches(request.defaultClearTerminalBinding, ctrlL);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapMainSurfaceActionKind.ClearTerminal
			&& request.conflictInnerAction == ModelKeymapMainSurfaceActionKind.ToggleFastMode
			&& request.expectedOuterActionName == ClearTerminalName
			&& request.expectedInnerActionName == ToggleFastModeName;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = configuredToggleFastModeBindingPreserved
			&& defaultClearTerminalBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapMainSurfaceConflictDecisionKind.KeymapMainSurfaceConflictRejected
			: ModelKeymapMainSurfaceConflictDecisionKind.KeymapMainSurfaceConflictMissed;

		return new ModelKeymapMainSurfaceConflictOutcome({
			ok: ok,
			code: ok ? "keymap_main_surface_conflict_modeled" : "keymap_main_surface_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			configuredToggleFastModeBindingPreserved: configuredToggleFastModeBindingPreserved,
			defaultClearTerminalBindingPreserved: defaultClearTerminalBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap main-surface conflict did not match upstream expectations"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapMainSurfaceConflictOutcome {
		return new ModelKeymapMainSurfaceConflictOutcome({
			ok: false,
			code: "keymap_main_surface_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapMainSurfaceConflictDecisionKind.KeymapMainSurfaceConflictMissed,
			configuredToggleFastModeBindingPreserved: false,
			defaultClearTerminalBindingPreserved: false,
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
