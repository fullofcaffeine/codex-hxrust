import codexhx.runtime.tui.resume.live.ResumePickerPaginationGate;

class ResumePickerPaginationRenderHarness {
	static function main():Void {
		final report = ResumePickerPaginationGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.pageLoads), "page loads");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "page next=cursor-2 moreBelow=true loadingOlder=false");
		assertContains(snapshots[2], "page next=cursor-2 moreBelow=true loadingOlder=true");
		assertContains(snapshots[2], "footer loading older selected=1 selectedThread=thread-b");
		assertContains(report.finalSnapshot, "> Preview renderer | thread-c | turns=8 | 2026-06-19T12:10:00Z");
		assertContains(report.finalSnapshot, "  Pagination renderer | thread-d | turns=13 | 2026-06-19T12:15:00Z");
		assertContains(report.finalSnapshot, "rows loaded=4 filtered=4 scanned=4 accepted=4");
		assertContains(report.finalSnapshot, "footer 100% selected=2 selectedThread=thread-c");
		assertContains(report.summary(), "request=page-2");

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
