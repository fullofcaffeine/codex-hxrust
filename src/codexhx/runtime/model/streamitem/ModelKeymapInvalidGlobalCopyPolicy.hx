package codexhx.runtime.model.streamitem;

class ModelKeymapInvalidGlobalCopyPolicy {
	static final NoFunctionNumber = -1;
	static final ExpectedErrorPath = "tui.keymap.global.copy";

	public static function apply(request:ModelKeymapInvalidGlobalCopyRequest):ModelKeymapInvalidGlobalCopyOutcome {
		if (request == null) return failure("", "missing keymap invalid global copy request");

		final invalidBindingPreserved = matches(request.configuredGlobalCopy, character("o", false, true, false));
		final errorPathPreserved = request.expectedErrorPath == ExpectedErrorPath;
		final parseFailurePreserved = request.parseFailed;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = invalidBindingPreserved && errorPathPreserved && parseFailurePreserved && eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeymapInvalidGlobalCopyDecisionKind.KeymapInvalidGlobalCopyPathPreserved
			: ModelKeymapInvalidGlobalCopyDecisionKind.KeymapInvalidGlobalCopyPathRejected;

		return new ModelKeymapInvalidGlobalCopyOutcome({
			ok: ok,
			code: ok ? "keymap_invalid_global_copy_path_modeled" : "keymap_invalid_global_copy_path_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			invalidBindingPreserved: invalidBindingPreserved,
			errorPathPreserved: errorPathPreserved,
			parseFailurePreserved: parseFailurePreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap invalid global copy path expectations were not satisfied"
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

	static function failure(requestId:String, errorMessage:String):ModelKeymapInvalidGlobalCopyOutcome {
		return new ModelKeymapInvalidGlobalCopyOutcome({
			ok: false,
			code: "keymap_invalid_global_copy_path_failed",
			requestId: requestId,
			decisionKind: ModelKeymapInvalidGlobalCopyDecisionKind.KeymapInvalidGlobalCopyPathRejected,
			invalidBindingPreserved: false,
			errorPathPreserved: false,
			parseFailurePreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
