package codexhx.runtime.model.streamitem;

class ModelKeymapComposerFixedShortcutConflictPolicy {
	static final NoFunctionNumber = -1;
	static final ComposerSubmitName = "composer.submit";
	static final FixedPasteImageName = "fixed.paste_image";

	public static function apply(request:ModelKeymapComposerFixedShortcutConflictRequest):ModelKeymapComposerFixedShortcutConflictOutcome {
		if (request == null)
			return failure("", "missing keymap composer/fixed-shortcut conflict request");

		final ctrlV = character("v", true, false, false);
		final configuredComposerSubmitBindingPreserved = matches(request.configuredComposerSubmitBinding, ctrlV);
		final fixedPasteImageBindingPreserved = matches(request.fixedPasteImageBinding, ctrlV);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapComposerFixedShortcutConflictActionKind.ComposerSubmit
			&& request.conflictInnerAction == ModelKeymapComposerFixedShortcutConflictActionKind.FixedPasteImage
			&& request.expectedOuterActionName == ComposerSubmitName
			&& request.expectedInnerActionName == FixedPasteImageName;
		final conflictRejectionPreserved = request.conflictRejected;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = configuredComposerSubmitBindingPreserved
			&& fixedPasteImageBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapComposerFixedShortcutConflictDecisionKind.KeymapComposerFixedShortcutConflictRejected : ModelKeymapComposerFixedShortcutConflictDecisionKind.KeymapComposerFixedShortcutConflictMissed;

		return new ModelKeymapComposerFixedShortcutConflictOutcome({
			ok: ok,
			code: ok ? "keymap_composer_fixed_shortcut_conflict_modeled" : "keymap_composer_fixed_shortcut_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			configuredComposerSubmitBindingPreserved: configuredComposerSubmitBindingPreserved,
			fixedPasteImageBindingPreserved: fixedPasteImageBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap composer/fixed-shortcut conflict did not match upstream expectations"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapComposerFixedShortcutConflictOutcome {
		return new ModelKeymapComposerFixedShortcutConflictOutcome({
			ok: false,
			code: "keymap_composer_fixed_shortcut_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapComposerFixedShortcutConflictDecisionKind.KeymapComposerFixedShortcutConflictMissed,
			configuredComposerSubmitBindingPreserved: false,
			fixedPasteImageBindingPreserved: false,
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
