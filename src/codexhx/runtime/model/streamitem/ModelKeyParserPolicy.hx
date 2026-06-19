package codexhx.runtime.model.streamitem;

class ModelKeyParserPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeyParserRequest):ModelKeyParserOutcome {
		if (request == null)
			return failure("", "missing key parser request");

		var acceptedFunctionKeyCount = 0;
		var rejectedFunctionKeyCount = 0;
		var namedKeyCount = 0;
		var spaceAliasPreserved = false;
		var minusAliasPreserved = false;
		var modifierOnlyRejected = false;
		var nonnumericFunctionRejected = false;
		var altMinusAliasPreserved = false;
		var legacyAltLiteralMinusPreserved = false;
		var literalMinusPreserved = false;
		var allExpectedCasesMatched = request.cases.length > 0;

		for (keyCase in request.cases) {
			final parsed = parse(keyCase.spec, request.maxFunctionKey);
			if (parsed.accepted && parsed.kind == ModelParsedKeyKind.Function)
				acceptedFunctionKeyCount++;
			if (!parsed.accepted && keyCase.expectedKind == ModelParsedKeyKind.Function)
				rejectedFunctionKeyCount++;
			if (parsed.accepted && parsed.kind == ModelParsedKeyKind.Named)
				namedKeyCount++;
			if (parsed.accepted && keyCase.spec == "space" && parsed.kind == ModelParsedKeyKind.Character && parsed.keyName == " ") {
				spaceAliasPreserved = true;
			}
			if (parsed.accepted && keyCase.spec == "minus" && parsed.kind == ModelParsedKeyKind.Character && parsed.keyName == "-") {
				minusAliasPreserved = true;
			}
			if (!parsed.accepted && keyCase.spec == "ctrl")
				modifierOnlyRejected = true;
			if (!parsed.accepted && keyCase.spec == "ff" && keyCase.expectedKind == ModelParsedKeyKind.Function) {
				nonnumericFunctionRejected = true;
			}
			if (isAltMinusCase(keyCase, parsed, "alt-minus"))
				altMinusAliasPreserved = true;
			if (isAltMinusCase(keyCase, parsed, "alt--"))
				legacyAltLiteralMinusPreserved = true;
			if (parsed.accepted
				&& keyCase.spec == "-"
				&& parsed.kind == ModelParsedKeyKind.Character
				&& parsed.keyName == "-"
				&& !parsed.hasAnyModifier()) {
				literalMinusPreserved = true;
			}
			if (!caseMatches(keyCase, parsed))
				allExpectedCasesMatched = false;
		}

		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = allExpectedCasesMatched && acceptedFunctionKeyCount == 2 && rejectedFunctionKeyCount == 2 && namedKeyCount >= 12 && spaceAliasPreserved
			&& minusAliasPreserved && modifierOnlyRejected && nonnumericFunctionRejected && altMinusAliasPreserved && legacyAltLiteralMinusPreserved
			&& literalMinusPreserved && eventOrderingPreserved;
		final decisionKind = ok ? ModelKeyParserDecisionKind.KeyParserCasesPreserved : ModelKeyParserDecisionKind.KeyParserCasesRejected;

		return new ModelKeyParserOutcome({
			ok: ok,
			code: ok ? "key_parser_cases_modeled" : "key_parser_cases_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			acceptedFunctionKeyCount: acceptedFunctionKeyCount,
			rejectedFunctionKeyCount: rejectedFunctionKeyCount,
			namedKeyCount: namedKeyCount,
			spaceAliasPreserved: spaceAliasPreserved,
			minusAliasPreserved: minusAliasPreserved,
			modifierOnlyRejected: modifierOnlyRejected,
			nonnumericFunctionRejected: nonnumericFunctionRejected,
			altMinusAliasPreserved: altMinusAliasPreserved,
			legacyAltLiteralMinusPreserved: legacyAltLiteralMinusPreserved,
			literalMinusPreserved: literalMinusPreserved,
			allExpectedCasesMatched: allExpectedCasesMatched,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "key parser cases did not match upstream expectations"
		});
	}

	static function caseMatches(keyCase:ModelKeyParserCase, parsed:ParsedKey):Bool {
		return parsed.accepted == keyCase.expectedAccepted
			&& parsed.kind == keyCase.expectedKind
			&& parsed.keyName == keyCase.expectedKeyName
			&& parsed.functionNumber == keyCase.expectedFunctionNumber
			&& parsed.ctrlModifier == keyCase.expectedCtrlModifier
			&& parsed.altModifier == keyCase.expectedAltModifier
			&& parsed.shiftModifier == keyCase.expectedShiftModifier;
	}

	static function parse(spec:String, maxFunctionKey:Int):ParsedKey {
		final normalized = spec == null ? "" : spec.toLowerCase();
		if (normalized.length == 0)
			return invalid();
		final keyParts = normalized.split("-");
		var ctrlModifier = false;
		var altModifier = false;
		var shiftModifier = false;
		var keyName:Null<String> = null;
		var index = 0;
		while (index < keyParts.length && keyName == null) {
			final part = keyParts[index];
			index++;
			switch part {
				case "ctrl":
					ctrlModifier = true;
				case "alt":
					altModifier = true;
				case "shift":
					shiftModifier = true;
				case _:
					keyName = part;
			}
		}
		if (keyName == null)
			return invalid();
		while (index < keyParts.length) {
			keyName += "-" + keyParts[index];
			index++;
		}

		if (keyName.length > 1 && keyName.charAt(0) == "f") {
			final digits = keyName.substr(1);
			final number = Std.parseInt(digits);
			if (number == null || "f" + number != keyName)
				return invalidFunction();
			if (number >= 1 && number <= maxFunctionKey) {
				return new ParsedKey(true, ModelParsedKeyKind.Function, keyName, number, ctrlModifier, altModifier, shiftModifier);
			}
			return invalidFunction();
		}

		return switch keyName {
			case "tab" | "backspace" | "esc" | "delete" | "up" | "down" | "left" | "right" | "home" | "end" | "page-up" | "page-down":
				new ParsedKey(true, ModelParsedKeyKind.Named, keyName, NoFunctionNumber, ctrlModifier, altModifier, shiftModifier);
			case "space":
				new ParsedKey(true, ModelParsedKeyKind.Character, " ", NoFunctionNumber, ctrlModifier, altModifier, shiftModifier);
			case "minus":
				new ParsedKey(true, ModelParsedKeyKind.Character, "-", NoFunctionNumber, ctrlModifier, altModifier, shiftModifier);
			case _:
				if (keyName.length == 1) {
					new ParsedKey(true, ModelParsedKeyKind.Character, keyName, NoFunctionNumber, ctrlModifier, altModifier, shiftModifier);
				} else {
					invalid();
				}
		}
	}

	static function isAltMinusCase(keyCase:ModelKeyParserCase, parsed:ParsedKey, spec:String):Bool {
		return parsed.accepted
			&& keyCase.spec == spec
			&& parsed.kind == ModelParsedKeyKind.Character
			&& parsed.keyName == "-"
			&& parsed.altModifier
			&& !parsed.ctrlModifier
			&& !parsed.shiftModifier;
	}

	static function invalidFunction():ParsedKey {
		return new ParsedKey(false, ModelParsedKeyKind.Function, "", NoFunctionNumber, false, false, false);
	}

	static function invalid():ParsedKey {
		return new ParsedKey(false, ModelParsedKeyKind.Invalid, "", NoFunctionNumber, false, false, false);
	}

	static function failure(requestId:String, errorMessage:String):ModelKeyParserOutcome {
		return new ModelKeyParserOutcome({
			ok: false,
			code: "key_parser_cases_failed",
			requestId: requestId,
			decisionKind: ModelKeyParserDecisionKind.KeyParserCasesRejected,
			acceptedFunctionKeyCount: 0,
			rejectedFunctionKeyCount: 0,
			namedKeyCount: 0,
			spaceAliasPreserved: false,
			minusAliasPreserved: false,
			modifierOnlyRejected: false,
			nonnumericFunctionRejected: false,
			altMinusAliasPreserved: false,
			legacyAltLiteralMinusPreserved: false,
			literalMinusPreserved: false,
			allExpectedCasesMatched: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}

class ParsedKey {
	public final accepted:Bool;
	public final kind:ModelParsedKeyKind;
	public final keyName:String;
	public final functionNumber:Int;
	public final ctrlModifier:Bool;
	public final altModifier:Bool;
	public final shiftModifier:Bool;

	public function new(accepted:Bool, kind:ModelParsedKeyKind, keyName:String, functionNumber:Int, ctrlModifier:Bool, altModifier:Bool, shiftModifier:Bool) {
		this.accepted = accepted;
		this.kind = kind;
		this.keyName = keyName == null ? "" : keyName;
		this.functionNumber = functionNumber;
		this.ctrlModifier = ctrlModifier;
		this.altModifier = altModifier;
		this.shiftModifier = shiftModifier;
	}

	public function hasAnyModifier():Bool {
		return ctrlModifier || altModifier || shiftModifier;
	}
}
