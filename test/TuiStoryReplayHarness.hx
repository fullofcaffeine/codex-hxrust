import codexhx.runtime.tui.CodexStoryMessageType;
import codexhx.runtime.tui.TuiStoryKind;
import codexhx.runtime.tui.TuiStoryReplayParser;
import sys.io.File;

class TuiStoryReplayHarness {
	static function main():Void {
		parsesSelectedOssStory();
		rejectsInvalidRecords();
	}

	static function parsesSelectedOssStory():Void {
		final fixture = File.getContent("fixtures/upstream/oss-story-selected.v1.jsonl");
		final summary = TuiStoryReplayParser.replaySummary(fixture);
		assertEquals("30", Std.string(summary.records));
		assertEquals("1", Std.string(summary.sessionStarts));
		assertEquals("1", Std.string(summary.sessionEnds));
		assertEquals("3", Std.string(summary.appEvents));
		assertEquals("6", Std.string(summary.keyEvents));
		assertEquals("15", Std.string(summary.codexEvents));
		assertEquals("3", Std.string(summary.insertHistoryEvents));
		assertEquals("15", Std.string(summary.insertedLines));
		assertEquals("1", Std.string(summary.operations));
		assertEquals("1", Std.string(summary.taskStarted));
		assertEquals("1", Std.string(summary.taskCompleted));
		assertEquals("9", Std.string(summary.agentMessageDeltaCount));
		assertEquals("2", Std.string(summary.reasoningDeltaCount));
		assertEquals("1", Std.string(summary.shutdownComplete));
		assertEquals("hello\\n", escapeText(summary.typedText));
		assertEquals("Hello! How can I help you today?", summary.assistantPreview);
		assertEquals("Thehello", summary.reasoningPreview);
		assertContains(summary.fingerprint(), "app=3:RequestRedraw,Redraw,Exit");
		assertContains(summary.fingerprint(),
			"codex=15:session_configured,task_started,agent_reasoning_raw_content_delta,agent_message_delta,task_complete,shutdown_complete");
		assertContains(summary.fingerprint(), "history=3/15");
		assertContains(summary.fingerprint(), "ops=1");
	}

	static function rejectsInvalidRecords():Void {
		final invalidKind = TuiStoryReplayParser.parseLine("{\"ts\":\"2025-08-10T03:12:26.500Z\",\"dir\":\"to_tui\",\"kind\":\"log_line\",\"line\":\"ignored\"}",
			1);
		assertFalse(invalidKind.ok, "unsupported story kinds must fail closed");
		assertEquals("invalid_kind", invalidKind.errorCode);

		final invalidKey = TuiStoryReplayParser.parseLine("{\"ts\":\"2025-08-10T03:12:26.500Z\",\"dir\":\"to_tui\",\"kind\":\"key_event\"}", 2);
		assertFalse(invalidKey.ok, "missing key event payload must fail");
		assertEquals("invalid_story_record", invalidKey.errorCode);
	}

	static function escapeText(value:String):String {
		return StringTools.replace(value, "\n", "\\n");
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}

	static function assertFalse(value:Bool, message:String):Void {
		if (value)
			throw message;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}
}
