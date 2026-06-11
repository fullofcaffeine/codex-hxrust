import codexhx.runtime.model.MockModelStreamParser;
import codexhx.runtime.model.ModelStreamParseOutcome;
import sys.io.File;

class MockModelStreamHarness {
    static function main():Void {
        parsesBasicOneTurnFixture();
        reportsMalformedStreamsDeterministically();
    }

    static function parsesBasicOneTurnFixture():Void {
        final stream = File.getContent("fixtures/upstream/mock-model-basic-one-turn.sse");
        final expected = StringTools.trim(File.getContent("fixtures/upstream/mock-model-basic-one-turn.events.golden.json"));
        final parsed = expectParse(MockModelStreamParser.parseSse(stream));
        assertEquals(expected, parsed.canonicalEventsJson());
        assertEquals("Hello world", parsed.assistantText);
        assertEquals("5", Std.string(parsed.events.length));
    }

    static function reportsMalformedStreamsDeterministically():Void {
        final malformedLine = MockModelStreamParser.parseSse("event: response.created\nwat\n");
        assertFalse(malformedLine.ok, "malformed line should fail");
        assertEquals("malformed_sse_line", malformedLine.errorCode);
        assertEquals("$.blocks[0].lines[1]", malformedLine.errorPath);

        final badJson = MockModelStreamParser.parseSse("event: response.created\ndata: {bad-json}\n\n");
        assertFalse(badJson.ok, "bad JSON should fail");
        assertEquals("invalid_json", badJson.errorCode);
        assertEquals("$.blocks[0].data", badJson.errorPath);

        final mismatch = MockModelStreamParser.parseSse("event: response.created\ndata: {\"type\":\"response.completed\",\"response\":{\"id\":\"resp-1\"}}\n\n");
        assertFalse(mismatch.ok, "event/data type mismatch should fail");
        assertEquals("event_type_mismatch", mismatch.errorCode);
        assertEquals("$.blocks[0].event", mismatch.errorPath);
    }

    static function expectParse(outcome:ModelStreamParseOutcome):ModelStreamParseOutcome {
        if (!outcome.ok) {
            throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        }
        return outcome;
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }
}
