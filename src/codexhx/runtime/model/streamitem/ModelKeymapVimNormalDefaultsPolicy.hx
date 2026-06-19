package codexhx.runtime.model.streamitem;

class ModelKeymapVimNormalDefaultsPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeymapVimNormalDefaultsRequest):ModelKeymapVimNormalDefaultsOutcome {
		if (request == null)
			return failure("", "missing keymap vim-normal defaults request");

		final enterInsertDefaultsPreserved = sameBindings(request.enterInsert, [character("i"), named("insert")]);
		final moveLeftDefaultsPreserved = sameBindings(request.moveLeft, [character("h"), named("left")]);
		final moveRightDefaultsPreserved = sameBindings(request.moveRight, [character("l"), named("right")]);
		final moveUpDefaultsPreserved = sameBindings(request.moveUp, [character("k"), named("up")]);
		final moveDownDefaultsPreserved = sameBindings(request.moveDown, [character("j"), named("down")]);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = enterInsertDefaultsPreserved && moveLeftDefaultsPreserved && moveRightDefaultsPreserved && moveUpDefaultsPreserved
			&& moveDownDefaultsPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeymapVimNormalDefaultsDecisionKind.KeymapVimNormalDefaultsPreserved : ModelKeymapVimNormalDefaultsDecisionKind.KeymapVimNormalDefaultsRejected;

		return new ModelKeymapVimNormalDefaultsOutcome({
			ok: ok,
			code: ok ? "keymap_vim_normal_defaults_modeled" : "keymap_vim_normal_defaults_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			enterInsertDefaultsPreserved: enterInsertDefaultsPreserved,
			moveLeftDefaultsPreserved: moveLeftDefaultsPreserved,
			moveRightDefaultsPreserved: moveRightDefaultsPreserved,
			moveUpDefaultsPreserved: moveUpDefaultsPreserved,
			moveDownDefaultsPreserved: moveDownDefaultsPreserved,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "keymap vim-normal defaults did not match upstream expectations"
		});
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

	static function character(keyName:String):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Character,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: false,
			altModifier: false,
			shiftModifier: false
		});
	}

	static function named(keyName:String):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: ModelParsedKeyKind.Named,
			keyName: keyName,
			functionNumber: NoFunctionNumber,
			ctrlModifier: false,
			altModifier: false,
			shiftModifier: false
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelKeymapVimNormalDefaultsOutcome {
		return new ModelKeymapVimNormalDefaultsOutcome({
			ok: false,
			code: "keymap_vim_normal_defaults_failed",
			requestId: requestId,
			decisionKind: ModelKeymapVimNormalDefaultsDecisionKind.KeymapVimNormalDefaultsRejected,
			enterInsertDefaultsPreserved: false,
			moveLeftDefaultsPreserved: false,
			moveRightDefaultsPreserved: false,
			moveUpDefaultsPreserved: false,
			moveDownDefaultsPreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
