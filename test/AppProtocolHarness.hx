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
        validatesPlanUpdates();
    }

    static function emitsSchemaFingerprint():Void {
        final fingerprintJson = AppProtocol.schemaFingerprintJson();
        assertContains(fingerprintJson, "\"schema\":\"codex-hxrust.app-protocol-fingerprint.v1\"");
        assertContains(fingerprintJson, "\"fingerprint\":\"" + AppProtocol.schemaFingerprint() + "\"");
        assertContains(fingerprintJson, "thread/start");
        assertContains(fingerprintJson, "turn/completed");
        assertContains(fingerprintJson, "turn/plan/updated");
        assertContains(fingerprintJson, "item/completed");
        assertContains(fingerprintJson, "item/agentMessage/delta");
        assertContains(fingerprintJson, "item/plan/delta");
        assertContains(fingerprintJson, "item/commandExecution/outputDelta");
        assertContains(fingerprintJson, "item/commandExecution/terminalInteraction");
        assertContains(fingerprintJson, "item/fileChange/outputDelta");
        assertContains(fingerprintJson, "item/fileChange/patchUpdated");
        assertContains(fingerprintJson, "rawResponseItem/completed");
        assertContains(fingerprintJson, "serverRequest/resolved");
        assertContains(fingerprintJson, "command/exec/outputDelta");
        assertContains(fingerprintJson, "process/outputDelta");
        assertContains(fingerprintJson, "process/exited");
        assertContains(fingerprintJson, "items:agentMessage,plan,userMessage");
    }

    static function roundTripsFixture():Void {
        final root = expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/app-protocol-roundtrip.v1.json")));
        final items = fixtureItems(root);
        assertEquals("29", Std.string(items.length));

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
        assertEquals("20", Std.string(notifications));
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

    static function validatesPlanUpdates():Void {
        final nullExplanation = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plan-null-explanation\",\"kind\":\"notification\",\"method\":\"turn/plan/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/plan/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"explanation\":null,\"plan\":[{\"step\":\"one\",\"status\":\"pending\"}]}}}")));
        assertTrue(nullExplanation.ok, "plan update should allow null explanation");

        final missingExplanation = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plan-missing-explanation\",\"kind\":\"notification\",\"method\":\"turn/plan/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/plan/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"plan\":[{\"step\":\"one\",\"status\":\"completed\"}]}}}")));
        assertTrue(missingExplanation.ok, "plan update should allow missing explanation");

        final invalidStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plan-invalid-status\",\"kind\":\"notification\",\"method\":\"turn/plan/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/plan/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"plan\":[{\"step\":\"one\",\"status\":\"blocked\"}]}}}")));
        assertFalse(invalidStatus.ok, "unknown plan status must fail");
        assertEquals("invalid_plan_step_status", invalidStatus.errorCode);
        assertEquals("$.message.params.plan[0].status", invalidStatus.errorPath);

        final invalidCommandStream = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-invalid-stream\",\"kind\":\"notification\",\"method\":\"command/exec/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"command/exec/outputDelta\",\"params\":{\"processId\":\"proc-1\",\"stream\":\"combined\",\"deltaBase64\":\"AQI=\",\"capReached\":false}}}")));
        assertFalse(invalidCommandStream.ok, "unknown command exec stream must fail");
        assertEquals("invalid_command_exec_stream", invalidCommandStream.errorCode);
        assertEquals("$.message.params.stream", invalidCommandStream.errorPath);

        final invalidProcessStream = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-invalid-stream\",\"kind\":\"notification\",\"method\":\"process/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"process/outputDelta\",\"params\":{\"processHandle\":\"proc-1\",\"stream\":\"combined\",\"deltaBase64\":\"AQI=\",\"capReached\":false}}}")));
        assertFalse(invalidProcessStream.ok, "unknown process output stream must fail");
        assertEquals("invalid_process_output_stream", invalidProcessStream.errorCode);
        assertEquals("$.message.params.stream", invalidProcessStream.errorPath);

        final invalidProcessExit = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-invalid-exit\",\"kind\":\"notification\",\"method\":\"process/exited\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"process/exited\",\"params\":{\"processHandle\":\"proc-1\",\"exitCode\":0,\"stdout\":\"out\",\"stdoutCapReached\":\"no\",\"stderr\":\"err\",\"stderrCapReached\":false}}}")));
        assertFalse(invalidProcessExit.ok, "process cap flags must be booleans");
        assertEquals("expected_bool", invalidProcessExit.errorCode);
        assertEquals("$.message.params.stdoutCapReached", invalidProcessExit.errorPath);

        final invalidCommandExecutionDelta = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-execution-invalid-delta\",\"kind\":\"notification\",\"method\":\"item/commandExecution/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/commandExecution/outputDelta\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"delta\":7}}}")));
        assertFalse(invalidCommandExecutionDelta.ok, "command execution delta must be a string");
        assertEquals("expected_string", invalidCommandExecutionDelta.errorCode);
        assertEquals("$.message.params.delta", invalidCommandExecutionDelta.errorPath);

        final invalidTerminalInteraction = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-execution-invalid-terminal-stdin\",\"kind\":\"notification\",\"method\":\"item/commandExecution/terminalInteraction\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/commandExecution/terminalInteraction\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"processId\":\"proc-1\",\"stdin\":false}}}")));
        assertFalse(invalidTerminalInteraction.ok, "terminal interaction stdin must be a string");
        assertEquals("expected_string", invalidTerminalInteraction.errorCode);
        assertEquals("$.message.params.stdin", invalidTerminalInteraction.errorPath);

        final invalidFileChangeDelta = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"file-change-invalid-delta\",\"kind\":\"notification\",\"method\":\"item/fileChange/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/fileChange/outputDelta\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"delta\":false}}}")));
        assertFalse(invalidFileChangeDelta.ok, "file change delta must be a string");
        assertEquals("expected_string", invalidFileChangeDelta.errorCode);
        assertEquals("$.message.params.delta", invalidFileChangeDelta.errorPath);

        final invalidPatchChangeKind = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"file-change-invalid-kind\",\"kind\":\"notification\",\"method\":\"item/fileChange/patchUpdated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/fileChange/patchUpdated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"changes\":[{\"path\":\"a.txt\",\"kind\":{\"type\":\"rename\"},\"diff\":\"@@\"}]}}}")));
        assertFalse(invalidPatchChangeKind.ok, "patch change kind must be add, delete, or update");
        assertEquals("invalid_patch_change_kind", invalidPatchChangeKind.errorCode);
        assertEquals("$.message.params.changes[0].kind.type", invalidPatchChangeKind.errorPath);

        final invalidPatchMovePath = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"file-change-invalid-move-path\",\"kind\":\"notification\",\"method\":\"item/fileChange/patchUpdated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/fileChange/patchUpdated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"changes\":[{\"path\":\"a.txt\",\"kind\":{\"type\":\"update\",\"move_path\":7},\"diff\":\"@@\"}]}}}")));
        assertFalse(invalidPatchMovePath.ok, "update move_path must be a string or null");
        assertEquals("expected_nullable_string", invalidPatchMovePath.errorCode);
        assertEquals("$.message.params.changes[0].kind.move_path", invalidPatchMovePath.errorPath);

        final invalidServerRequestId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-request-invalid-id\",\"kind\":\"notification\",\"method\":\"serverRequest/resolved\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"serverRequest/resolved\",\"params\":{\"threadId\":\"thread-1\",\"requestId\":false}}}")));
        assertFalse(invalidServerRequestId.ok, "server request id must be a string or number");
        assertEquals("expected_request_id", invalidServerRequestId.errorCode);
        assertEquals("$.message.params.requestId", invalidServerRequestId.errorPath);
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
