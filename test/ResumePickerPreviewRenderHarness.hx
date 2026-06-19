import codexhx.runtime.tui.resume.live.ResumePickerPreviewRenderGate;

class ResumePickerPreviewRenderHarness {
	static function main():Void {
		final report = ResumePickerPreviewRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("1", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.previewLoads), "preview loads");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "no rows loaded");
		assertContains(snapshots[1], "> Resume kernel | thread-a");
		assertContains(snapshots[2], "preview: loading preview...");
		assertContains(report.finalSnapshot, "preview: user: continue");
		assertContains(report.finalSnapshot, "preview: assistant: preview ready");
		assertContains(report.finalSnapshot, "footer 100% selected=0 selectedThread=thread-a");
		assertContains(report.summary(), "kind=preview_loaded");

		Sys.println(report.finalSnapshot.split("\n").join("\\n"));
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}
}
