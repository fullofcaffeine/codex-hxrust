package codexhx.runtime.model.streamitem;

class ModelKeymapFixedShortcutPolicy {
	static final NoFunctionNumber = -1;
	static final CopyName = "copy";
	static final IncreaseReasoningName = "chat.increase_reasoning_effort";

	public static function apply(request:ModelKeymapFixedShortcutRequest):ModelKeymapFixedShortcutOutcome {
		if (request == null)
			return failure("", "missing keymap fixed shortcut request");

		final altDot = character(".", false, true, false);
		final configuredCopyBindingPreserved = matches(request.configuredCopyBinding, altDot);
		final defaultIncreaseReasoningBindingPreserved = matches(request.defaultIncreaseReasoningBinding, altDot);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapFixedShortcutActionKind.GlobalCopy
			&& request.conflictInnerAction == ModelKeymapFixedShortcutActionKind.ChatIncreaseReasoningEffort
			&& request.expectedOuterActionName == CopyName
			&& request.expectedInnerActionName == IncreaseReasoningName;
		final conflictRejectionPreserved = request.conflictRejected;
		final originalActionUnboundPreserved = request.increaseReasoningUnbound;
		final runtimeCopyRemapPreserved = request.runtimeAcceptedAfterUnbind && matches(request.runtimeCopyBinding, altDot);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = configuredCopyBindingPreserved
			&& defaultIncreaseReasoningBindingPreserved
			&& conflictActionNamesPreserved
			&& conflictRejectionPreserved
			&& originalActionUnboundPreserved
			&& runtimeCopyRemapPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapFixedShortcutDecisionKind.KeymapFixedShortcutConflictPreserved : ModelKeymapFixedShortcutDecisionKind.KeymapFixedShortcutConflictRejected;

		return new ModelKeymapFixedShortcutOutcome({
			ok: ok,
			code: ok ? "keymap_fixed_shortcut_conflict_modeled" : "keymap_fixed_shortcut_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			configuredCopyBindingPreserved: configuredCopyBindingPreserved,
			defaultIncreaseReasoningBindingPreserved: defaultIncreaseReasoningBindingPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			originalActionUnboundPreserved: originalActionUnboundPreserved,
			runtimeCopyRemapPreserved: runtimeCopyRemapPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap fixed shortcut conflict did not match upstream expectations"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapFixedShortcutOutcome {
		return new ModelKeymapFixedShortcutOutcome({
			ok: false,
			code: "keymap_fixed_shortcut_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapFixedShortcutDecisionKind.KeymapFixedShortcutConflictRejected,
			configuredCopyBindingPreserved: false,
			defaultIncreaseReasoningBindingPreserved: false,
			conflictActionNamesPreserved: false,
			conflictRejectionPreserved: false,
			originalActionUnboundPreserved: false,
			runtimeCopyRemapPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
