import codexhx.validation.tui.resume.live.SelectionPreservationGate;

class ResumePickerReloadSelectionPreservationRenderHarness {
	static function main():Void {
		final report = SelectionPreservationGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("3", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.preservedSelections), "preserved selections");
		assertEquals("1", Std.string(report.fallbackSelections), "fallback selections");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "> Stable selected kernel | thread-stable | turns=5 | 2026-06-19T16:05:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[0], "footer selected stable row selected=1 selectedThread=thread-stable");
		assertContains(snapshots[1], "rows loaded=3 filtered=3 scanned=4 accepted=3 invalid=1");
		assertContains(snapshots[1], "> Stable selected kernel | thread-stable | turns=5 | 2026-06-19T16:05:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[1], "loader status=selection_preserved_by_thread detail=selected=thread-stable;index=2;previousIndex=1");
		assertContains(snapshots[1], "footer selection preserved selected=2 selectedThread=thread-stable");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0");
		assertContains(report.finalSnapshot, "> Fallback kernel match | thread-fallback | turns=13 | 2026-06-19T16:20:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "loader status=selection_fallback_first_row detail=missing=thread-stable;selected=thread-fallback;index=0");
		assertContains(report.finalSnapshot, "footer selection fallback selected=0 selectedThread=thread-fallback");
		assertNotContains(report.finalSnapshot, "Stable selected kernel | thread-stable");
		assertContains(report.summary(),
			"preserved:query=kernel;rows=3;selected=2;thread=thread-stable;footer=selection preserved;loader=selection_preserved_by_thread");
		assertContains(report.summary(),
			"fallback:query=kernel;rows=2;selected=0;thread=thread-fallback;footer=selection fallback;loader=selection_fallback_first_row");
		assertContains(report.summary(), "request=preserve-selection-page");
		assertContains(report.summary(), "request=fallback-selection-page");

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
