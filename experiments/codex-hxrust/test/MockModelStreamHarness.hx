import codexhx.runtime.model.MockModelProvider;
import codexhx.runtime.model.MockModelStreamParser;
import codexhx.runtime.model.ModelStreamParseOutcome;
import codexhx.runtime.model.ModelStreamRequest;
import sys.io.File;

class MockModelStreamHarness {
    static function main():Void {
        parsesBasicOneTurnFixture();
        mockProviderStartsAndCancelsFixtureStream();
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

    static function mockProviderStartsAndCancelsFixtureStream():Void {
        final provider = new MockModelProvider("fixtures/upstream/mock-model-basic-one-turn.sse");
        final request = new ModelStreamRequest("req-mock-1", "mock-model", "Say hello");
        final started = provider.startStream(request);
        assertTrue(started.ok, "mock provider start should succeed");
        assertEquals("mock", started.handle.provider);
        assertEquals("mock-stream-1", started.handle.streamId);
        assertEquals("req-mock-1", started.handle.requestId);

        final parsed = expectParse(MockModelStreamParser.parseSse(started.stream));
        assertEquals("Hello world", parsed.assistantText);

        final cancelled = provider.cancelStream(started.handle);
        assertTrue(cancelled.ok, "mock provider cancel should succeed");
        assertEquals("mock-stream-1", cancelled.streamId);

        final cancelledAgain = provider.cancelStream(started.handle);
        assertFalse(cancelledAgain.ok, "mock provider double cancel should fail");
        assertEquals("stream_not_active", cancelledAgain.errorCode);
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

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }
}
