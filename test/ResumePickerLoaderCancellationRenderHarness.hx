import codexhx.runtime.tui.resume.live.ResumePickerLoaderCancellationRenderGate;

class ResumePickerLoaderCancellationRenderHarness {
	static function main():Void {
		final report = ResumePickerLoaderCancellationRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("1", Std.string(report.pageLoads), "page loads");
		assertEquals("3", Std.string(report.staleIgnored), "stale ignored");
		assertTrue(report.cancellationObserved, "loader cancellation should be observed");
		assertEquals("6", Std.string(report.frameRequests), "frame requests");
		assertEquals("6", Std.string(report.renderCount), "render count");
		assertEquals("6", Std.string(snapshots.length), "snapshot count");
		assertEquals(report.baselineSummary, report.finalSummary, "stale/cancelled events should not mutate stable picker state");
		assertContains(snapshots[2], "loader status=stale_page_ignored detail=page-stale");
		assertContains(snapshots[2], "footer stale page ignored selected=0 selectedThread=thread-a");
		assertContains(snapshots[2], "> Resume kernel | thread-a");
		assertNotContains(snapshots[2], "Stale result");
		assertContains(snapshots[3], "loader status=stale_preview_ignored detail=preview-stale:thread-b");
		assertNotContains(snapshots[3], "assistant: stale preview");
		assertContains(snapshots[4], "loader status=stale_transcript_ignored detail=transcript-stale:thread-b");
		assertNotContains(snapshots[4], "assistant: stale transcript");
		assertContains(report.finalSnapshot, "loader status=loader_cancelled detail=consumer_dropped");
		assertContains(report.finalSnapshot, "footer loader cancelled selected=0 selectedThread=thread-a");
		assertContains(report.summary(), "kind=page_loaded;request=page-stale");
		assertContains(report.summary(), "kind=preview_loaded;request=preview-stale;thread=thread-b");
		assertContains(report.summary(), "kind=transcript_loaded;request=transcript-stale;thread=thread-b");

		Sys.println(report.summary());
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0) throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertNotContains(value:String, needle:String):Void {
		if (value.indexOf(needle) >= 0) throw "did not expect `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual) throw label + " expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value) throw message;
	}
}
