package codexhx.runtime.model.streamitem;

class ModelKeymapEditorUnbindConflictPolicy {
	static final NoFunctionNumber = -1;
	static final KillLineStartName = "kill_line_start";
	static final KillWholeLineName = "kill_whole_line";

	public static function apply(request:ModelKeymapEditorUnbindConflictRequest):ModelKeymapEditorUnbindConflictOutcome {
		if (request == null)
			return failure("", "missing keymap editor unbind conflict request");

		final ctrlU = character("u", true, false, false);
		final configuredKillWholeLinePreserved = matches(request.configuredKillWholeLine, ctrlU);
		final defaultKillLineStartPreserved = matches(request.defaultKillLineStart, ctrlU);
		final conflictActionNamesPreserved = request.conflictOuterAction == ModelKeymapEditorUnbindConflictActionKind.KillLineStart
			&& request.conflictInnerAction == ModelKeymapEditorUnbindConflictActionKind.KillWholeLine
			&& request.expectedOuterActionName == KillLineStartName
			&& request.expectedInnerActionName == KillWholeLineName;
		final conflictRejectionPreserved = request.conflictRejected;
		final originalActionUnboundPreserved = request.killLineStartUnbound;
		final runtimeKillWholeLinePreserved = request.runtimeAcceptedAfterUnbind && matches(request.runtimeKillWholeLine, ctrlU);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = configuredKillWholeLinePreserved && defaultKillLineStartPreserved && conflictActionNamesPreserved && conflictRejectionPreserved
			&& originalActionUnboundPreserved && runtimeKillWholeLinePreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapEditorUnbindConflictDecisionKind.KeymapEditorUnbindConflictPreserved : ModelKeymapEditorUnbindConflictDecisionKind.KeymapEditorUnbindConflictRejected;

		return new ModelKeymapEditorUnbindConflictOutcome({
			ok: ok,
			code: ok ? "keymap_editor_unbind_conflict_modeled" : "keymap_editor_unbind_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			configuredKillWholeLinePreserved: configuredKillWholeLinePreserved,
			defaultKillLineStartPreserved: defaultKillLineStartPreserved,
			conflictActionNamesPreserved: conflictActionNamesPreserved,
			conflictRejectionPreserved: conflictRejectionPreserved,
			originalActionUnboundPreserved: originalActionUnboundPreserved,
			runtimeKillWholeLinePreserved: runtimeKillWholeLinePreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap editor unbind conflict did not match upstream expectations"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapEditorUnbindConflictOutcome {
		return new ModelKeymapEditorUnbindConflictOutcome({
			ok: false,
			code: "keymap_editor_unbind_conflict_failed",
			requestId: requestId,
			decisionKind: ModelKeymapEditorUnbindConflictDecisionKind.KeymapEditorUnbindConflictRejected,
			configuredKillWholeLinePreserved: false,
			defaultKillLineStartPreserved: false,
			conflictActionNamesPreserved: false,
			conflictRejectionPreserved: false,
			originalActionUnboundPreserved: false,
			runtimeKillWholeLinePreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
