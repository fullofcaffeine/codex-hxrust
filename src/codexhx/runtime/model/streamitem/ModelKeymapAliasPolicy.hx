package codexhx.runtime.model.streamitem;

class ModelKeymapAliasPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapAliasRequest):ModelKeymapAliasOutcome {
		if (request == null) return failure("", "missing keymap alias request");

		final emptyArrayUnbindPreserved = request.composerToggleShortcutsConfiguredEmpty
			&& request.composerToggleShortcutCount == 0;
		final rawOutputDefaultAltRPreserved = matches(request.defaultRawOutputToggle, character("r", false, true, false));
		final rawOutputRemapF12Preserved = matches(request.remappedRawOutputToggle, functionKey(12, false, false, false));
		final editorNewlineAliasesPreserved = containsAll(request.editorInsertNewlineBindings, [
			character("j", true, false, false),
			character("m", true, false, false),
			named("enter", false, false, false),
			named("enter", false, false, true),
			named("enter", false, true, false)
		]) && request.editorInsertNewlineBindings.length == 5;
		final deleteForwardWordAltDPreserved = contains(
			request.editorDeleteForwardWordBindings,
			character("d", false, true, false)
		);
		final modifiedDeletionAliasesPreserved = containsAll(request.editorDeleteBackwardBindings, [
			named("backspace", false, false, true)
		]) && containsAll(request.editorDeleteForwardBindings, [
			named("delete", false, false, true)
		]) && containsAll(request.editorDeleteBackwardWordBindings, [
			named("backspace", true, false, false),
			named("backspace", true, false, true)
		]) && containsAll(request.editorDeleteForwardWordBindings, [
			named("delete", true, false, false),
			named("delete", true, false, true)
		]);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = emptyArrayUnbindPreserved
			&& rawOutputDefaultAltRPreserved
			&& rawOutputRemapF12Preserved
			&& editorNewlineAliasesPreserved
			&& deleteForwardWordAltDPreserved
			&& modifiedDeletionAliasesPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapAliasDecisionKind.KeymapAliasesPreserved
			: ModelKeymapAliasDecisionKind.KeymapAliasesRejected;

		return new ModelKeymapAliasOutcome({
			ok: ok,
			code: ok ? "keymap_aliases_modeled" : "keymap_aliases_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			emptyArrayUnbindPreserved: emptyArrayUnbindPreserved,
			rawOutputDefaultAltRPreserved: rawOutputDefaultAltRPreserved,
			rawOutputRemapF12Preserved: rawOutputRemapF12Preserved,
			editorNewlineAliasesPreserved: editorNewlineAliasesPreserved,
			deleteForwardWordAltDPreserved: deleteForwardWordAltDPreserved,
			modifiedDeletionAliasesPreserved: modifiedDeletionAliasesPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap aliases did not match upstream expectations"
		});
	}

	static function containsAll(actual:Array<ModelKeymapBinding>, expected:Array<ModelKeymapBinding>):Bool {
		for (binding in expected) {
			if (!contains(actual, binding)) return false;
		}
		return true;
	}

	static function contains(actual:Array<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		if (actual == null) return false;
		for (binding in actual) {
			if (matches(binding, expected)) return true;
		}
		return false;
	}

	static function matches(actual:ModelKeymapBinding, expected:ModelKeymapBinding):Bool {
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

	static function functionKey(
		functionNumber:Int,
		ctrlModifier:Bool,
		altModifier:Bool,
		shiftModifier:Bool
	):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Function,
			keyName: "f" + functionNumber,
			functionNumber: functionNumber,
			ctrlModifier: ctrlModifier,
			altModifier: altModifier,
			shiftModifier: shiftModifier
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelKeymapAliasOutcome {
		return new ModelKeymapAliasOutcome({
			ok: false,
			code: "keymap_aliases_failed",
			requestId: requestId,
			decisionKind: ModelKeymapAliasDecisionKind.KeymapAliasesRejected,
			emptyArrayUnbindPreserved: false,
			rawOutputDefaultAltRPreserved: false,
			rawOutputRemapF12Preserved: false,
			editorNewlineAliasesPreserved: false,
			deleteForwardWordAltDPreserved: false,
			modifiedDeletionAliasesPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
