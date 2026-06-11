import codexhx.protocol.app.AppProtocol;
import codexhx.protocol.app.AppProtocolMessage;
import codexhx.protocol.app.AppProtocolParseOutcome;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;
import sys.io.File;

class AppProtocolHarness {
    static function main():Void {
        emitsSchemaFingerprint();
        roundTripsFixture();
        mapsErrorsDeterministically();
    }

    static function emitsSchemaFingerprint():Void {
        final fingerprintJson = AppProtocol.schemaFingerprintJson();
        assertContains(fingerprintJson, "\"schema\":\"codex-hxrust.app-protocol-fingerprint.v1\"");
        assertContains(fingerprintJson, "\"fingerprint\":\"" + AppProtocol.schemaFingerprint() + "\"");
        assertContains(fingerprintJson, "thread/start");
        assertContains(fingerprintJson, "turn/completed");
    }

    static function roundTripsFixture():Void {
        final root = expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/app-protocol-roundtrip.v1.json")));
        final items = fixtureItems(root);
        assertEquals("14", Std.string(items.length));

        var requests = 0;
        var responses = 0;
        var notifications = 0;
        var errors = 0;

        for (item in items) {
            final parsed = expectProtocol(AppProtocol.parseFixtureItem(item));
            final canonical = parsed.canonicalJson;
            final reparsed = expectParse(CodexJson.parse(canonical));
            final canonicalAgain = JsonValueCodec.encode(reparsed);
            assertEquals(canonical, canonicalAgain);
            assertEquals(AppProtocol.schemaFingerprint(), parsed.schemaFingerprint);

            if (parsed.kind == "request") requests = requests + 1;
            if (parsed.kind == "response") responses = responses + 1;
            if (parsed.kind == "notification") notifications = notifications + 1;
            if (parsed.kind == "error") errors = errors + 1;
        }

        assertEquals("4", Std.string(requests));
        assertEquals("4", Std.string(responses));
        assertEquals("5", Std.string(notifications));
        assertEquals("1", Std.string(errors));
    }

    static function mapsErrorsDeterministically():Void {
        final jsonrpcError = expectProtocol(AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"jsonrpc-error\",\"kind\":\"error\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":99,\"error\":{\"code\":-32602,\"message\":\"invalid params\",\"data\":{\"field\":\"threadId\"}}}}"))));
        assertEquals("{\"error\":{\"code\":-32602,\"data\":{\"field\":\"threadId\"},\"message\":\"invalid params\"},\"id\":99,\"jsonrpc\":\"2.0\"}", jsonrpcError.canonicalJson);

        assertFalse(AppProtocol.errorAffectsTurnStatus(JString("threadRollbackFailed")), "rollback errors should not mark the turn failed");
        assertTrue(AppProtocol.errorAffectsTurnStatus(JString("other")), "generic errors should affect the turn");
        assertFalse(AppProtocol.errorAffectsTurnStatus(expectParse(CodexJson.parse("{\"activeTurnNotSteerable\":{\"turnKind\":\"review\"}}"))), "non-steerable active turns should not mark the turn failed");

        final unsupported = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"bad-image-input\",\"kind\":\"request\",\"method\":\"turn/start\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":7,\"method\":\"turn/start\",\"params\":{\"threadId\":\"thread-1\",\"input\":[{\"type\":\"image\",\"url\":\"file:///tmp/a.png\"}]}}}")));
        assertFalse(unsupported.ok, "image input must fail in this text-only subset");
        assertEquals("unsupported_user_input", unsupported.errorCode);
        assertEquals("$.message.params.input[0].type", unsupported.errorPath);
    }

    static function fixtureItems(root:Value):Array<Value> {
        return switch root {
            case JObject(keys, values):
                final i = fieldIndex(keys, "items");
                if (i < 0) throw "fixture is missing items";
                switch values[i] {
                    case JArray(entries):
                        entries;
                    case _:
                        throw "fixture items must be an array";
                }
            case _:
                throw "fixture root must be an object";
        }
    }

    static function expectParse(outcome:JsonParseOutcome):Value {
        if (!outcome.ok) {
            throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        }
        return outcome.value;
    }

    static function expectProtocol(outcome:AppProtocolParseOutcome):AppProtocolMessage {
        if (!outcome.ok) {
            throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        }
        return outcome.message;
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }

    static function assertContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) < 0) throw "expected `" + haystack + "` to contain `" + needle + "`";
    }
}
