import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonValueCodec;
import codexhx.runtime.app.HeadlessJsonlAdapter;
import haxe.json.Value;
import sys.io.File;

class HeadlessJsonlAdapterHarness {
    static function main():Void {
        runsFixtureScript();
        reportsUnsupportedRequests();
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

    static function reportsUnsupportedRequests():Void {
        final adapter = new HeadlessJsonlAdapter("fixtures/upstream/mock-model-basic-one-turn.sse");
        final missingStart = adapter.dispatchJsonl("{\"command\":\"submit\",\"id\":\"cmd-before-start\",\"prompt\":\"Say hello\"}\n");
        assertEquals("{\"command\":\"submit\",\"errorCode\":\"thread_not_started\",\"errorMessage\":\"start must be called before submit\",\"id\":\"cmd-before-start\",\"kind\":\"error\",\"ok\":false}\n",
            missingStart);

        final badCommand = adapter.dispatchJsonl("{\"command\":\"tool/call\",\"id\":\"cmd-unsupported\"}\n");
        assertEquals("{\"command\":\"tool/call\",\"errorCode\":\"unsupported_command\",\"errorMessage\":\"unsupported adapter command\",\"id\":\"cmd-unsupported\",\"kind\":\"error\",\"ok\":false}\n",
            badCommand);
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
