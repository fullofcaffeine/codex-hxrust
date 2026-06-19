package codexhx.runtime.model.streamitem;

class ModelKeymapDefaultPruningPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapDefaultPruningRequest):ModelKeymapDefaultPruningOutcome {
		if (request == null)
			return failure("", "missing keymap default pruning request");

		final tailMainSurfaceDefaultsPreserved = tailMainSurfaceDefaultsMatch(request.tailMainSurfaceDefaults);
		final listPageAndJumpDefaultsPreserved = listDefaultsMatch(request.listPageAndJumpDefaults);
		final reasoningFallbackPruningPreserved = matches(request.configuredEditorMoveUp, named("up", false, false, true))
			&& matches(request.configuredVimTextObjectWord, named("down", false, false, true))
			&& sameBindings(request.prunedDecreaseReasoningBindings, [character(",", false, true, false)])
			&& sameBindings(request.prunedIncreaseReasoningBindings, [character(".", false, true, false)]);
		final explicitReasoningEditorConflictPreserved = request.explicitConflictOuterAction == ModelKeymapDefaultPruningActionKind.ChatIncreaseReasoningEffort
			&& request.explicitConflictInnerAction == ModelKeymapDefaultPruningActionKind.EditorMoveUp
			&& matches(request.explicitConflictBinding, named("up", false, false, true));
		final legacyListOverlapPruningPreserved = matches(request.legacyListMoveUpConfigured, named("page-up", false, false, false))
			&& matches(request.legacyListMoveDownConfigured, named("page-down", false, false, false))
			&& sameBindings(request.legacyListPageUpPruned, [character("b", true, false, false)])
			&& sameBindings(request.legacyListPageDownPruned, [character("f", true, false, false)]);
		final legacyListPruneAllDefaultsPreserved = sameBindings(request.legacyListPruneAllMoveUpConfigured,
			[named("page-up", false, false, false), character("b", true, false, false)])
			&& sameBindings(request.legacyListPruneAllRuntimeMoveUp, [named("page-up", false, false, false), character("b", true, false, false)])
			&& request.legacyListPruneAllPageUpPruned.length == 0;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = tailMainSurfaceDefaultsPreserved
			&& listPageAndJumpDefaultsPreserved
			&& reasoningFallbackPruningPreserved
			&& explicitReasoningEditorConflictPreserved
			&& legacyListOverlapPruningPreserved
			&& legacyListPruneAllDefaultsPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapDefaultPruningDecisionKind.KeymapDefaultPruningPreserved : ModelKeymapDefaultPruningDecisionKind.KeymapDefaultPruningRejected;

		return new ModelKeymapDefaultPruningOutcome({
			ok: ok,
			code: ok ? "keymap_default_pruning_modeled" : "keymap_default_pruning_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			tailMainSurfaceDefaultsPreserved: tailMainSurfaceDefaultsPreserved,
			listPageAndJumpDefaultsPreserved: listPageAndJumpDefaultsPreserved,
			reasoningFallbackPruningPreserved: reasoningFallbackPruningPreserved,
			explicitReasoningEditorConflictPreserved: explicitReasoningEditorConflictPreserved,
			legacyListOverlapPruningPreserved: legacyListOverlapPruningPreserved,
			legacyListPruneAllDefaultsPreserved: legacyListPruneAllDefaultsPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap default pruning did not match upstream expectations"
		});
	}

	static function tailMainSurfaceDefaultsMatch(actions:Array<ModelKeymapDefaultPruningCase>):Bool {
		if (actions.length != 4)
			return false;
		return actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.EditQueuedMessage,
			[named("up", false, true, false), named("left", false, false, true)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.HistorySearchPrevious, [character("r", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.HistorySearchNext, [character("s", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.KillWholeLine, []);
	}

	static function listDefaultsMatch(actions:Array<ModelKeymapDefaultPruningCase>):Bool {
		if (actions.length != 8)
			return false;
		return actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListMoveUp, [
			named("up", false, false, false),
			character("p", true, false, false),
			character("k", true, false, false),
			character("k", false, false, false)
		])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListMoveDown,
				[
					named("down", false, false, false),
					character("n", true, false, false),
					character("j", true, false, false),
					character("j", false, false, false)
				])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListMoveLeft,
				[named("left", false, false, false), character("h", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListMoveRight,
				[named("right", false, false, false), character("l", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListPageUp,
				[named("page-up", false, false, false), character("b", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListPageDown,
				[named("page-down", false, false, false), character("f", true, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListJumpTop, [named("home", false, false, false)])
			&& actionBindingsMatch(actions, ModelKeymapDefaultPruningActionKind.ListJumpBottom, [named("end", false, false, false)]);
	}

	static function actionBindingsMatch(actions:Array<ModelKeymapDefaultPruningCase>, actionKind:ModelKeymapDefaultPruningActionKind,
			expected:Array<ModelKeymapBinding>):Bool {
		for (action in actions) {
			if (action.actionKind == actionKind)
				return sameBindings(action.bindings, expected);
		}
		return false;
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapDefaultPruningOutcome {
		return new ModelKeymapDefaultPruningOutcome({
			ok: false,
			code: "keymap_default_pruning_failed",
			requestId: requestId,
			decisionKind: ModelKeymapDefaultPruningDecisionKind.KeymapDefaultPruningRejected,
			tailMainSurfaceDefaultsPreserved: false,
			listPageAndJumpDefaultsPreserved: false,
			reasoningFallbackPruningPreserved: false,
			explicitReasoningEditorConflictPreserved: false,
			legacyListOverlapPruningPreserved: false,
			legacyListPruneAllDefaultsPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
