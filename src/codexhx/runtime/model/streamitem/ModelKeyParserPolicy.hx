package codexhx.runtime.model.streamitem;

class ModelKeyParserPolicy {
	static final NoFunctionNumber = -1;

	public static function apply(request:ModelKeyParserRequest):ModelKeyParserOutcome {
		if (request == null) return failure("", "missing key parser request");

		var acceptedFunctionKeyCount = 0;
		var rejectedFunctionKeyCount = 0;
		var namedKeyCount = 0;
		var spaceAliasPreserved = false;
		var minusAliasPreserved = false;
		var allExpectedCasesMatched = request.cases.length > 0;

		for (keyCase in request.cases) {
			final parsed = parse(keyCase.spec, request.maxFunctionKey);
			if (parsed.accepted && parsed.kind == ModelParsedKeyKind.Function) acceptedFunctionKeyCount++;
			if (!parsed.accepted && keyCase.expectedKind == ModelParsedKeyKind.Function) rejectedFunctionKeyCount++;
			if (parsed.accepted && parsed.kind == ModelParsedKeyKind.Named) namedKeyCount++;
			if (parsed.accepted && parsed.keyName == "space") spaceAliasPreserved = true;
			if (parsed.accepted && parsed.keyName == "minus") minusAliasPreserved = true;
			if (!caseMatches(keyCase, parsed)) allExpectedCasesMatched = false;
		}

		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = allExpectedCasesMatched
			&& acceptedFunctionKeyCount == 2
			&& rejectedFunctionKeyCount == 1
			&& namedKeyCount >= 12
			&& spaceAliasPreserved
			&& minusAliasPreserved
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelKeyParserDecisionKind.KeyParserCasesPreserved
			: ModelKeyParserDecisionKind.KeyParserCasesRejected;

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
			&& parsed.functionNumber == keyCase.expectedFunctionNumber;
	}

	static function parse(spec:String, maxFunctionKey:Int):ParsedKey {
		final normalized = spec == null ? "" : spec.toLowerCase();
		if (normalized.length == 0) return invalid();
		if (normalized.length > 1 && normalized.charAt(0) == "f") {
			final digits = normalized.substr(1);
			final number = Std.parseInt(digits);
			if (number == null || "f" + number != normalized) return invalidFunction();
			if (number >= 1 && number <= maxFunctionKey) {
				return new ParsedKey(true, ModelParsedKeyKind.Function, normalized, number);
			}
			return invalidFunction();
		}

		return switch normalized {
			case "tab" | "backspace" | "esc" | "delete" | "up" | "down" | "left" | "right" | "home" | "end" | "page-up" | "page-down" | "space" | "minus":
				new ParsedKey(true, ModelParsedKeyKind.Named, normalized, NoFunctionNumber);
			case _:
				if (normalized.length == 1) {
					new ParsedKey(true, ModelParsedKeyKind.Character, normalized, NoFunctionNumber);
				} else {
					invalid();
				}
		}
	}

	static function invalidFunction():ParsedKey {
		return new ParsedKey(false, ModelParsedKeyKind.Function, "", NoFunctionNumber);
	}

	static function invalid():ParsedKey {
		return new ParsedKey(false, ModelParsedKeyKind.Invalid, "", NoFunctionNumber);
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

	public function new(accepted:Bool, kind:ModelParsedKeyKind, keyName:String, functionNumber:Int) {
		this.accepted = accepted;
		this.kind = kind;
		this.keyName = keyName == null ? "" : keyName;
		this.functionNumber = functionNumber;
	}
}
