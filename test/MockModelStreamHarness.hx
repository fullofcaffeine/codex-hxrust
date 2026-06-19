import codexhx.runtime.model.MockModelProvider;
import codexhx.runtime.model.MockModelStreamParser;
import codexhx.runtime.model.ModelStreamParseOutcome;
import codexhx.runtime.model.ModelStreamRequest;
import codexhx.runtime.session.OneTurnInterruptPolicy;
import codexhx.runtime.session.OneTurnSessionOutcome;
import codexhx.runtime.session.OneTurnSessionRunner;
import codexhx.state.TranscriptStateStore;
import sys.FileSystem;
import sys.io.File;

class MockModelStreamHarness {
	static function main():Void {
		parsesBasicOneTurnFixture();
		mockProviderStartsAndCancelsFixtureStream();
		runsOneTurnSessionToDeterministicTerminalState();
		cancelsOneTurnSessionAtSafeCheckpoint();
		writesTranscriptAndStateArtifacts();
		reportsSessionErrorsAsStructuredEvents();
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

	static function runsOneTurnSessionToDeterministicTerminalState():Void {
		final expected = StringTools.trim(File.getContent("fixtures/upstream/mock-model-basic-one-turn.events.golden.json"));
		final provider = new MockModelProvider("fixtures/upstream/mock-model-basic-one-turn.sse");
		final outcome = expectSession(OneTurnSessionRunner.run(provider, new ModelStreamRequest("req-session-1", "mock-model", "Say hello")));
		assertEquals("completed", outcome.terminalState);
		assertEquals("mock-stream-1", outcome.streamId);
		assertEquals("Hello world", outcome.assistantText);
		assertEquals(expected, outcome.canonicalEventsJson());
	}

	static function cancelsOneTurnSessionAtSafeCheckpoint():Void {
		final baseDir = "generated/mock-model-cancel-state";
		resetStateDir(baseDir);

		final provider = new MockModelProvider("fixtures/upstream/mock-model-basic-one-turn.sse");
		final outcome = expectSession(OneTurnSessionRunner.runWithInterrupt(provider, new ModelStreamRequest("req-cancel-1", "mock-model", "Say hello"),
			OneTurnInterruptPolicy.afterEvents(2)));
		assertEquals("cancelled", outcome.terminalState);
		assertEquals("mock-stream-1", outcome.streamId);
		assertEquals("Hello", outcome.assistantText);
		assertEquals("3", Std.string(outcome.events.length));
		assertEquals("session_cancelled", outcome.events[2].kind);
		assertEquals("cancelled", outcome.events[2].errorCode);
		assertFalse(provider.hasActiveStream(outcome.streamId), "cancelled mock stream should not remain active");

		final written = TranscriptStateStore.writeOneTurn(baseDir, outcome);
		assertTrue(written.ok, "cancel state write should succeed");
		final expectedTranscript = File.getContent("fixtures/hxrust/mock-one-turn-cancel-transcript.v1.jsonl");
		final expectedState = File.getContent("fixtures/hxrust/mock-one-turn-cancel-state.v1.json");
		final actualTranscript = File.getContent(written.transcriptPath);
		final actualState = File.getContent(written.statePath);
		assertEquals(expectedTranscript, actualTranscript);
		assertEquals(expectedState, actualState);
		assertNotContains(actualTranscript + actualState, "Say hello");

		final lateProvider = new MockModelProvider("fixtures/upstream/mock-model-basic-one-turn.sse");
		final lateOutcome = expectSession(OneTurnSessionRunner.runWithInterrupt(lateProvider,
			new ModelStreamRequest("req-cancel-late", "mock-model", "Say hello"), OneTurnInterruptPolicy.afterEvents(99)));
		assertEquals("completed", lateOutcome.terminalState);
		assertEquals("5", Std.string(lateOutcome.events.length));
	}

	static function writesTranscriptAndStateArtifacts():Void {
		final baseDir = "generated/mock-model-state";
		resetStateDir(baseDir);

		final provider = new MockModelProvider("fixtures/upstream/mock-model-basic-one-turn.sse");
		final outcome = expectSession(OneTurnSessionRunner.run(provider, new ModelStreamRequest("req-state-1", "mock-model", "Say hello")));
		final written = TranscriptStateStore.writeOneTurn(baseDir, outcome);
		assertTrue(written.ok, "state write should succeed");

		final expectedTranscript = File.getContent("fixtures/hxrust/mock-one-turn-transcript.v1.jsonl");
		final expectedState = File.getContent("fixtures/hxrust/mock-one-turn-state.v1.json");
		final actualTranscript = File.getContent(written.transcriptPath);
		final actualState = File.getContent(written.statePath);
		assertEquals(expectedTranscript, actualTranscript);
		assertEquals(expectedState, actualState);
		assertNotContains(actualTranscript + actualState, "Say hello");

		final loaded = TranscriptStateStore.loadState(written.statePath);
		assertTrue(loaded.ok, "valid state should load");
		assertEquals(expectedState, loaded.content);

		final corruptPath = baseDir + "/corrupt-state.json";
		File.saveContent(corruptPath, "{bad-json");
		final corrupt = TranscriptStateStore.loadState(corruptPath);
		assertFalse(corrupt.ok, "corrupt state should fail");
		assertEquals("invalid_state_json", corrupt.errorCode);
		assertEquals("$", corrupt.errorPath);
	}

	static function reportsSessionErrorsAsStructuredEvents():Void {
		final provider = new MockModelProvider("fixtures/upstream/missing-model-stream.sse");
		final outcome = OneTurnSessionRunner.run(provider, new ModelStreamRequest("req-session-error", "mock-model", "Say hello"));
		assertFalse(outcome.ok, "missing provider fixture should fail");
		assertEquals("failed", outcome.terminalState);
		assertEquals("fixture_read_failed", outcome.errorCode);
		assertEquals("1", Std.string(outcome.events.length));
		assertEquals("session_error", outcome.events[0].kind);
		assertEquals("fixture_read_failed", outcome.events[0].errorCode);
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

	static function expectSession(outcome:OneTurnSessionOutcome):OneTurnSessionOutcome {
		if (!outcome.ok) {
			throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		}
		return outcome;
	}

	static function resetStateDir(baseDir:String):Void {
		if (!FileSystem.exists("generated")) {
			FileSystem.createDirectory("generated");
		}
		if (!FileSystem.exists(baseDir)) {
			FileSystem.createDirectory(baseDir);
		}
		deleteIfExists(baseDir + "/transcript.jsonl");
		deleteIfExists(baseDir + "/transcript.jsonl.tmp");
		deleteIfExists(baseDir + "/state.json");
		deleteIfExists(baseDir + "/state.json.tmp");
		deleteIfExists(baseDir + "/corrupt-state.json");
	}

	static function deleteIfExists(path:String):Void {
		if (FileSystem.exists(path)) {
			FileSystem.deleteFile(path);
		}
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected `" + expected + "`, got `" + actual + "`";
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}

	static function assertFalse(value:Bool, message:String):Void {
		if (value)
			throw message;
	}

	static function assertNotContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) >= 0)
			throw "expected `" + haystack + "` not to contain `" + needle + "`";
	}
}
