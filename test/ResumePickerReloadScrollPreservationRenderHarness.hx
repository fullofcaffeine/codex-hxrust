import codexhx.validation.tui.resume.live.ScrollPreservationGate;

class ResumePickerReloadScrollPreservationRenderHarness {
	static function main():Void {
		final report = ScrollPreservationGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("3", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.preservedScrolls), "preserved scrolls");
		assertEquals("1", Std.string(report.clampedScrolls), "clamped scrolls");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "navigation selected=4 scrollTop=2 viewRows=3 moreAbove=true pageDownCompleted=false");
		assertContains(snapshots[0], "> Anchor scroll row | thread-anchor | turns=5 | 2026-06-19T17:04:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[0], "footer scrolled active selected=4 selectedThread=thread-anchor");
		assertContains(snapshots[1], "rows loaded=6 filtered=6 scanned=7 accepted=6 invalid=1");
		assertContains(snapshots[1], "navigation selected=4 scrollTop=2 viewRows=3 moreAbove=true pageDownCompleted=false");
		assertContains(snapshots[1], "loader status=scroll_preserved_by_window detail=selected=thread-anchor;index=4;scrollTop=2;previousScrollTop=2");
		assertContains(snapshots[1], "footer scroll preserved selected=4 selectedThread=thread-anchor");
		assertContains(report.finalSnapshot, "rows loaded=3 filtered=3 scanned=3 accepted=3 invalid=0");
		assertContains(report.finalSnapshot, "> Anchor scroll row | thread-anchor | turns=5 | 2026-06-19T17:04:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot,
			"loader status=scroll_clamped_after_shrink detail=selected=thread-anchor;index=2;scrollTop=0;previousScrollTop=2;maxScrollTop=0");
		assertContains(report.finalSnapshot, "footer scroll clamped selected=2 selectedThread=thread-anchor");
		assertNotContains(report.finalSnapshot, "navigation selected=");
		assertContains(report.summary(),
			"preserved:query=scroll;rows=6;selected=4;thread=thread-anchor;scrollTop=2;viewRows=3;moreAbove=true;moreBelow=false;footer=scroll preserved;loader=scroll_preserved_by_window");
		assertContains(report.summary(),
			"clamped:query=scroll;rows=3;selected=2;thread=thread-anchor;scrollTop=0;viewRows=3;moreAbove=false;moreBelow=false;footer=scroll clamped;loader=scroll_clamped_after_shrink");
		assertContains(report.summary(), "request=preserve-scroll-page");
		assertContains(report.summary(), "request=clamp-scroll-page");

		Sys.println(report.summary());
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertNotContains(value:String, needle:String):Void {
		if (value.indexOf(needle) >= 0)
			throw "did not expect `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}
}
