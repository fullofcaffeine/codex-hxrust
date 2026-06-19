import codexhx.protocol.json.BoolOutcome;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.protocol.json.NumberOutcome;
import codexhx.protocol.json.SerdeBridge;
import codexhx.protocol.json.StringOutcome;
import haxe.json.Value;

class JsonBoundaryHarness {
	static function main():Void {
		parsesTypedObject();
		mapsErrorsDeterministically();
		reportsUnknownFields();
		encodesDeterministically();
	}

	static function parsesTypedObject():Void {
		final json = "{\"model\":\"gpt-5.2-codex\",\"ok\":true,\"count\":2,\"extra\":\"ignored\"}";
		assertEquals("gpt-5.2-codex", expectString(CodexJson.stringField(expectParse(SerdeBridge.parse(json)), "model", "$")).value);
		assertTrue(expectBool(CodexJson.boolField(expectParse(SerdeBridge.parse(json)), "ok", "$")).value, "ok should be true");
		assertEquals("2", Std.string(expectNumber(CodexJson.numberField(expectParse(SerdeBridge.parse(json)), "count", "$")).value));
	}

	static function mapsErrorsDeterministically():Void {
		final missing = CodexJson.stringField(expectParse(CodexJson.parse("{\"ok\":true}")), "model", "$");
		assertFalse(missing.ok, "missing field should fail");
		assertEquals("missing_field", missing.errorCode);
		assertEquals("$.model", missing.errorPath);

		final wrongType = CodexJson.stringField(expectParse(CodexJson.parse("{\"model\":7}")), "model", "$");
		assertFalse(wrongType.ok, "wrong type should fail");
		assertEquals("expected_string", wrongType.errorCode);
	}

	static function reportsUnknownFields():Void {
		final parsed = expectParse(CodexJson.parse("{\"model\":\"gpt-5\",\"extra\":\"x\"}"));
		final unknown = CodexJson.unknownFields(parsed, ["model"]);
		assertEquals("1", Std.string(unknown.length));
		assertEquals("extra", unknown[0]);
	}

	static function encodesDeterministically():Void {
		final encoded = SerdeBridge.encodeStringObject(["schema", "model"], ["codex.test", "gpt-5"]);
		assertEquals("{\"schema\":\"codex.test\",\"model\":\"gpt-5\"}", encoded);
	}

	static function expectParse(outcome:JsonParseOutcome):Value {
		if (!outcome.ok) {
			throw "expected JSON parse success: " + outcome.errorCode;
		}
		return outcome.value;
	}

	static function expectString(outcome:StringOutcome):StringOutcome {
		if (!outcome.ok)
			throw outcome.errorCode + " at " + outcome.errorPath;
		return outcome;
	}

	static function expectBool(outcome:BoolOutcome):BoolOutcome {
		if (!outcome.ok)
			throw outcome.errorCode + " at " + outcome.errorPath;
		return outcome;
	}

	static function expectNumber(outcome:NumberOutcome):NumberOutcome {
		if (!outcome.ok)
			throw outcome.errorCode + " at " + outcome.errorPath;
		return outcome;
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual) {
			throw "expected `" + expected + "`, got `" + actual + "`";
		}
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}

	static function assertFalse(value:Bool, message:String):Void {
		if (value)
			throw message;
	}
}
