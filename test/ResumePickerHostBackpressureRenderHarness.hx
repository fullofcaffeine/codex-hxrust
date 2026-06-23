import codexhx.runtime.tui.resume.live.HostBackpressureGate;

class ResumePickerHostBackpressureRenderHarness {
	static function main():Void {
		final report = HostBackpressureGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.bestEffortDropped, "best-effort frame should drop when bounded stream is full");
		assertTrue(report.losslessBackpressured, "lossless page should report backpressure when bounded stream is full");
		assertTrue(report.recoverySucceeded, "lossless page should enqueue after draining the stream");
		assertEquals("1", Std.string(report.skippedEvents), "best-effort skipped count");
		assertEquals("0", Std.string(report.pendingEvents), "final pending count");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=best_effort_frame_dropped detail=pending=1;skipped=1");
		assertContains(snapshots[1], "footer frame drop selected=0 selectedThread=<empty>");
		assertContains(snapshots[2], "loader status=lossless_page_backpressured detail=pending=1;skipped=1");
		assertContains(snapshots[2], "footer page backpressure selected=0 selectedThread=<empty>");
		assertContains(report.finalSnapshot, "loader status=backpressure_recovered detail=pending=0;skipped=1");
		assertContains(report.finalSnapshot, "> Recovered page | thread-c");
		assertContains(report.finalSnapshot, "footer backpressure recovered selected=2 selectedThread=thread-c");
		assertContains(report.summary(), "frame-2:kind=backpressured");
		assertContains(report.summary(), "best_effort_dropped");
		assertContains(report.summary(), "page-2-blocked:kind=backpressured");
		assertContains(report.summary(), "lossless_backpressure");
		assertContains(report.summary(), "page-2-recovered:kind=ready");
		assertContains(report.summary(), "kind=frame_requested;request=;thread=;detail=draw-1");
		assertContains(report.summary(), "kind=page_loaded;request=page-2");

		Sys.println(report.summary());
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
