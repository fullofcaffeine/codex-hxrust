import codexhx.runtime.tui.resume.live.ResumePickerScanCapRenderGate;

class ResumePickerScanCapRenderHarness {
	static function main():Void {
		final report = ResumePickerScanCapRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("3", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.scanCapPageLoads), "scan-cap page loads");
		assertEquals("2", Std.string(report.ordinaryPageLoads), "ordinary page loads");
		assertEquals("5", Std.string(report.frameRequests), "frame requests");
		assertEquals("5", Std.string(report.renderCount), "render count");
		assertEquals("5", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "rows loaded=2 filtered=2 scanned=64 accepted=2 invalid=1");
		assertContains(snapshots[1], "page next=cursor-after-cap moreBelow=true loadingOlder=false scanCap=true nextPresent=true");
		assertContains(snapshots[1], "loader status=scan_cap_reached detail=scanCap=true;next=cursor-after-cap;scanned=64");
		assertContains(snapshots[1], "footer scan cap reached selected=0 selectedThread=thread-cap-a");
		assertContains(snapshots[2], "page next=cursor-after-cap moreBelow=true loadingOlder=true scanCap=true nextPresent=true");
		assertContains(snapshots[2], "footer loading capped cursor selected=0 selectedThread=thread-cap-a");
		assertContains(snapshots[3], "rows loaded=4 filtered=4 scanned=66 accepted=4 invalid=1");
		assertContains(snapshots[3], "page next=cursor-tail moreBelow=true loadingOlder=false scanCap=false nextPresent=true");
		assertContains(snapshots[3], "loader status=scan_cap_cleared detail=scanCap=false;next=cursor-tail;scanned=66");
		assertContains(report.finalSnapshot, "rows loaded=5 filtered=5 scanned=67 accepted=5 invalid=1");
		assertContains(report.finalSnapshot, "> Recovered final row | thread-final | turns=14 | 2026-06-19T13:20:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "loader status=scan_cap_recovered detail=scanCap=false;next=<empty>;scanned=67");
		assertContains(report.finalSnapshot, "footer list recovered selected=4 selectedThread=thread-final");
		assertContains(report.summary(), "request=scan-cap-page");
		assertContains(report.summary(), "scanCap=true");
		assertContains(report.summary(), "request=ordinary-page");
		assertContains(report.summary(), "scanCap=false");

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
}
