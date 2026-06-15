package codexhx.runtime.model.streamitem;

class ModelKeymapShadowPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapShadowRequest):ModelKeymapShadowOutcome {
		if (request == null) return failure("", "missing keymap shadow request");

		final canonicalBindingPreserved = matches(
			request.canonicalBinding,
			new ModelKeymapBinding({
				kind: ModelParsedKeyKind.Character,
				keyName: "a",
				functionNumber: NoFunctionNumber,
				ctrlModifier: true,
				altModifier: true,
				shiftModifier: true
			})
		);
		var shadowConflictCount = 0;
		var composerShadowRejected = false;
		var editorShadowRejected = false;
		var approvalShadowRejected = false;
		var listShadowRejected = false;
		var actionNamesPreserved = request.shadowCases.length > 0;

		for (shadowCase in request.shadowCases) {
			final validCase = shadowCase.outerActionName.length > 0
				&& shadowCase.innerActionName.length > 0
				&& shadowCase.binding != null;
			if (!validCase) actionNamesPreserved = false;
			if (validCase) shadowConflictCount++;
			switch shadowCase.scope {
				case ModelKeymapShadowScopeKind.Composer:
					composerShadowRejected = composerShadowRejected || validCase;
				case ModelKeymapShadowScopeKind.Editor:
					editorShadowRejected = editorShadowRejected || validCase;
				case ModelKeymapShadowScopeKind.Approval:
					approvalShadowRejected = approvalShadowRejected || validCase;
				case ModelKeymapShadowScopeKind.List:
					listShadowRejected = listShadowRejected || validCase;
				case _:
					actionNamesPreserved = false;
			}
		}

		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = canonicalBindingPreserved
			&& shadowConflictCount == 4
			&& composerShadowRejected
			&& editorShadowRejected
			&& approvalShadowRejected
			&& listShadowRejected
			&& actionNamesPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapShadowDecisionKind.KeymapShadowConflictsRejected
			: ModelKeymapShadowDecisionKind.KeymapShadowConflictsMissed;

		return new ModelKeymapShadowOutcome({
			ok: ok,
			code: ok ? "keymap_shadow_conflicts_modeled" : "keymap_shadow_conflicts_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			canonicalBindingPreserved: canonicalBindingPreserved,
			shadowConflictCount: shadowConflictCount,
			composerShadowRejected: composerShadowRejected,
			editorShadowRejected: editorShadowRejected,
			approvalShadowRejected: approvalShadowRejected,
			listShadowRejected: listShadowRejected,
			actionNamesPreserved: actionNamesPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap shadow conflicts did not match upstream expectations"
		});
	}

	static function matches(actual:Null<ModelKeymapBinding>, expected:ModelKeymapBinding):Bool {
		return actual != null && actual.equals(expected);
	}

	static function failure(requestId:String, errorMessage:String):ModelKeymapShadowOutcome {
		return new ModelKeymapShadowOutcome({
			ok: false,
			code: "keymap_shadow_conflicts_failed",
			requestId: requestId,
			decisionKind: ModelKeymapShadowDecisionKind.KeymapShadowConflictsMissed,
			canonicalBindingPreserved: false,
			shadowConflictCount: 0,
			composerShadowRejected: false,
			editorShadowRejected: false,
			approvalShadowRejected: false,
			listShadowRejected: false,
			actionNamesPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
