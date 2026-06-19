import codexhx.runtime.tui.resume.live.ResumePickerTranscriptOverlayRenderGate;

class ResumePickerTranscriptOverlayRenderHarness {
	static function main():Void {
		final report = ResumePickerTranscriptOverlayRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.transcriptLoads), "transcript loads");
		assertEquals("1", Std.string(report.fallbackLoads), "fallback loads");
		assertEquals("5", Std.string(report.frameRequests), "frame requests");
		assertEquals("5", Std.string(report.renderCount), "render count");
		assertEquals("5", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "overlay loading thread=thread-detail message=Loading transcript...");
		assertContains(snapshots[2], "overlay transcript thread=thread-detail cells=3");
		assertContains(snapshots[2], "transcript: user: continue");
		assertContains(snapshots[2], "transcript: assistant: transcript detail ready");
		assertContains(snapshots[3], "overlay loading thread=thread-empty message=Loading transcript...");
		assertContains(report.finalSnapshot, "overlay transcript thread=thread-empty cells=1");
		assertContains(report.finalSnapshot, "transcript: fallback: No transcript content");
		assertContains(report.finalSnapshot, "footer fallback selected=1 selectedThread=thread-empty");
		assertContains(report.summary(), "request=transcript-empty");

		Sys.println(report.finalSnapshot.split("\n").join("\\n"));
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0) throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual) throw label + " expected " + expected + " but got " + actual;
	}
}
