import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonValueCodec;
import codexhx.runtime.app.HeadlessJsonlAdapter;
import haxe.json.Value;
import sys.io.File;

class HeadlessJsonlAdapterHarness {
    static function main():Void {
        runsFixtureScript();
        runsUpstreamAppServerFixtureScript();
        reportsUnsupportedRequests();
        reportsDeterministicInterruptErrors();
    }

    static function runsFixtureScript():Void {
        final adapter = new HeadlessJsonlAdapter("fixtures/upstream/mock-model-basic-one-turn.sse");
        final input = File.getContent("fixtures/hxrust/headless-jsonl-adapter-input.v1.jsonl");
        final expected = File.getContent("fixtures/hxrust/headless-jsonl-adapter-output.v1.jsonl");
        final actual = adapter.dispatchJsonl(input);
        assertEquals(expected, actual);
        assertNotContains(actual, "Say hello");
        assertCanonicalJsonl(actual);
    }

    static function runsUpstreamAppServerFixtureScript():Void {
        final adapter = new HeadlessJsonlAdapter("fixtures/upstream/mock-model-basic-one-turn.sse");
        final input = File.getContent("fixtures/hxrust/headless-jsonl-app-server-input.v1.jsonl");
        final expected = File.getContent("fixtures/hxrust/headless-jsonl-app-server-output.v1.jsonl");
        final actual = adapter.dispatchJsonl(input);
        assertEquals(expected, actual);
        assertNotContains(actual, "\"prompt\"");
        assertCanonicalJsonl(actual);
    }

    static function reportsUnsupportedRequests():Void {
        final adapter = new HeadlessJsonlAdapter("fixtures/upstream/mock-model-basic-one-turn.sse");
        final missingStart = adapter.dispatchJsonl("{\"command\":\"submit\",\"id\":\"cmd-before-start\",\"prompt\":\"Say hello\"}\n");
        assertEquals("{\"command\":\"submit\",\"errorCode\":\"thread_not_started\",\"errorMessage\":\"start must be called before submit\",\"id\":\"cmd-before-start\",\"kind\":\"error\",\"ok\":false}\n",
            missingStart);

        final badCommand = adapter.dispatchJsonl("{\"command\":\"tool/call\",\"id\":\"cmd-unsupported\"}\n");
        assertEquals("{\"command\":\"tool/call\",\"errorCode\":\"unsupported_command\",\"errorMessage\":\"unsupported adapter command\",\"id\":\"cmd-unsupported\",\"kind\":\"error\",\"ok\":false}\n",
            badCommand);

        final unsupportedMethod = adapter.dispatchJsonl("{\"jsonrpc\":\"2.0\",\"id\":\"app-unsupported\",\"method\":\"tool/call\",\"params\":{}}\n");
        assertEquals("{\"error\":{\"code\":-32601,\"data\":{\"errorCode\":\"unsupported_method\"},\"message\":\"unsupported app-server method\"},\"id\":\"app-unsupported\",\"jsonrpc\":\"2.0\"}\n",
            unsupportedMethod);
    }

    static function reportsDeterministicInterruptErrors():Void {
        final beforeStart = new HeadlessJsonlAdapter("fixtures/upstream/mock-model-basic-one-turn.sse");
        final missingThread = beforeStart.dispatchJsonl("{\"jsonrpc\":\"2.0\",\"id\":\"app-interrupt-before-start\",\"method\":\"turn/interrupt\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\"}}\n");
        assertEquals("{\"error\":{\"code\":-32000,\"data\":{\"errorCode\":\"thread_not_started\"},\"message\":\"thread/start must be called before turn/interrupt\"},\"id\":\"app-interrupt-before-start\",\"jsonrpc\":\"2.0\"}\n",
            missingThread);

        final idle = new HeadlessJsonlAdapter("fixtures/upstream/mock-model-basic-one-turn.sse");
        idle.dispatchJsonl("{\"jsonrpc\":\"2.0\",\"id\":\"app-thread-start\",\"method\":\"thread/start\",\"params\":{}}\n");
        final noTurn = idle.dispatchJsonl("{\"jsonrpc\":\"2.0\",\"id\":\"app-interrupt-idle\",\"method\":\"turn/interrupt\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\"}}\n");
        assertEquals("{\"error\":{\"code\":-32000,\"data\":{\"errorCode\":\"turn_not_active\"},\"message\":\"no active turn to interrupt\"},\"id\":\"app-interrupt-idle\",\"jsonrpc\":\"2.0\"}\n",
            noTurn);
    }

    static function assertCanonicalJsonl(jsonl:String):Void {
        final lines = StringTools.replace(jsonl, "\r\n", "\n").split("\n");
        for (line in lines) {
            final trimmed = StringTools.trim(line);
            if (trimmed.length == 0) continue;
            final parsed = expectJson(CodexJson.parse(trimmed));
            assertEquals(trimmed, JsonValueCodec.encode(parsed));
        }
    }

    static function expectJson(outcome:codexhx.protocol.json.JsonParseOutcome):Value {
        if (!outcome.ok) {
            throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        }
        return outcome.value;
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertNotContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) >= 0) throw "expected `" + haystack + "` not to contain `" + needle + "`";
    }
}
