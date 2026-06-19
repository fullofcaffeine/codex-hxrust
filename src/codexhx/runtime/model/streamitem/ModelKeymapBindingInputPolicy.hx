package codexhx.runtime.model.streamitem;

class ModelKeymapBindingInputPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapBindingInputRequest):ModelKeymapBindingInputOutcome {
		if (request == null)
			return failure("", "missing keymap binding input request");

		final stringOrArrayInputValidated = request.invalidModifierRejected
			&& request.invalidMultiBindingPath == "tui.keymap.composer.submit"
			&& request.validMultiBindings.length == 2
			&& contains(request.validMultiBindings, named("enter", true, false, false))
			&& contains(request.validMultiBindings, named("enter", true, false, true));
		final invalidModifierPathPreserved = request.invalidModifierRejected
			&& request.invalidMultiBindingPath == "tui.keymap.composer.submit";
		final dedupeOrderPreserved = sameBindings(dedupe(request.dedupeInputBindings), request.dedupeExpectedBindings)
			&& request.dedupeExpectedBindings.length == 2;
		final contextFallbackPreserved = matches(request.globalQueueBinding, character("q", true, false, false))
			&& matches(request.composerQueueResolved, request.globalQueueBinding);
		final invalidGlobalPathsPreserved = request.invalidGlobalOpenTranscriptPath == "tui.keymap.global.open_transcript"
			&& request.invalidGlobalOpenExternalEditorPath == "tui.keymap.global.open_external_editor";
		final defaultCopyBindingPreserved = matches(request.defaultCopyBinding, character("o", true, false, false));
		final defaultMainSurfaceActionsPreserved = defaultActionMatches(request.defaultMainSurfaceActions);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = stringOrArrayInputValidated && invalidModifierPathPreserved && dedupeOrderPreserved && contextFallbackPreserved
			&& invalidGlobalPathsPreserved && defaultCopyBindingPreserved && defaultMainSurfaceActionsPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapBindingInputDecisionKind.KeymapBindingInputsPreserved : ModelKeymapBindingInputDecisionKind.KeymapBindingInputsRejected;

		return new ModelKeymapBindingInputOutcome({
			ok: ok,
			code: ok ? "keymap_binding_inputs_modeled" : "keymap_binding_inputs_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			stringOrArrayInputValidated: stringOrArrayInputValidated,
			invalidModifierPathPreserved: invalidModifierPathPreserved,
			validMultiBindingCount: request.validMultiBindings.length,
			dedupeOrderPreserved: dedupeOrderPreserved,
			contextFallbackPreserved: contextFallbackPreserved,
			invalidGlobalPathsPreserved: invalidGlobalPathsPreserved,
			defaultCopyBindingPreserved: defaultCopyBindingPreserved,
			defaultMainSurfaceActionsPreserved: defaultMainSurfaceActionsPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap binding inputs did not match upstream expectations"
		});
	}

	static function defaultActionMatches(actions:Array<ModelKeymapDefaultActionCase>):Bool {
		if (actions.length != 5)
			return false;
		return actionBindingsMatch(actions, ModelKeymapMainSurfaceActionKind.ClearTerminal, [character("l", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapMainSurfaceActionKind.ToggleFastMode, [])
			&& actionBindingsMatch(actions, ModelKeymapMainSurfaceActionKind.InterruptTurn, [named("esc", false, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapMainSurfaceActionKind.DecreaseReasoningEffort,
				[character(",", false, true, false), named("down", false, false, true)])
			&& actionBindingsMatch(actions, ModelKeymapMainSurfaceActionKind.IncreaseReasoningEffort,
				[character(".", false, true, false), named("up", false, false, true)]);
	}

	static function actionBindingsMatch(actions:Array<ModelKeymapDefaultActionCase>, actionKind:ModelKeymapMainSurfaceActionKind,
			expected:Array<ModelKeymapBinding>):Bool {
		for (action in actions) {
			if (action.actionKind == actionKind)
				return sameBindings(action.bindings, expected);
		}
		return false;
	}

	static function dedupe(bindings:Array<ModelKeymapBinding>):Array<ModelKeymapBinding> {
		final result:Array<ModelKeymapBinding> = [];
		for (binding in bindings) {
			if (!contains(result, binding))
				result.push(binding);
		}
		return result;
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

	static function contains(actual:Array<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		if (actual == null)
			return false;
		for (binding in actual) {
			if (matches(binding, expected))
				return true;
		}
		return false;
	}

	static function matches(actual:Null<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		return actual != null && actual.equals(expected);
	}

	static function named(keyName:String, ctrlModifier:Bool, altModifier:Bool, shiftModifier:Bool):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Named,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: ctrlModifier,
			altModifier: altModifier,
			shiftModifier: shiftModifier
		});
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapBindingInputOutcome {
		return new ModelKeymapBindingInputOutcome({
			ok: false,
			code: "keymap_binding_inputs_failed",
			requestId: requestId,
			decisionKind: ModelKeymapBindingInputDecisionKind.KeymapBindingInputsRejected,
			stringOrArrayInputValidated: false,
			invalidModifierPathPreserved: false,
			validMultiBindingCount: 0,
			dedupeOrderPreserved: false,
			contextFallbackPreserved: false,
			invalidGlobalPathsPreserved: false,
			defaultCopyBindingPreserved: false,
			defaultMainSurfaceActionsPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
