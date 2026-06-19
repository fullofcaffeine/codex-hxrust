import codexhx.runtime.tui.resume.live.ResumePickerReloadPreviewInvalidationRenderGate;

class ResumePickerReloadPreviewInvalidationRenderHarness {
	static function main():Void {
		final report = ResumePickerReloadPreviewInvalidationRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("3", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.previewLoads), "preview loads");
		assertEquals("1", Std.string(report.preservedPreviews), "preserved previews");
		assertEquals("1", Std.string(report.invalidatedPreviews), "invalidated previews");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "> Preview anchor | thread-a | turns=3 | 2026-06-19T18:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[0], "preview: user: inspect reload");
		assertContains(snapshots[0], "preview: assistant: preview survives same thread");
		assertContains(snapshots[0], "footer preview loaded selected=0 selectedThread=thread-a");
		assertContains(snapshots[1], "rows loaded=3 filtered=3 scanned=4 accepted=3 invalid=1");
		assertContains(snapshots[1], "> Preview anchor | thread-a | turns=3 | 2026-06-19T18:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[1], "preview: user: inspect reload");
		assertContains(snapshots[1], "loader status=preview_preserved_for_selected_thread detail=selected=thread-a;index=1;expanded=thread-a;previewLines=2");
		assertContains(snapshots[1], "footer preview preserved selected=1 selectedThread=thread-a");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0");
		assertContains(report.finalSnapshot, "> Fallback preview target | thread-b | turns=5 | 2026-06-19T18:05:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "loader status=preview_invalidated_after_selection_change detail=missing=thread-a;selected=thread-b;expandedCleared=true;pendingCleared=true;previewLines=0");
		assertContains(report.finalSnapshot, "footer preview invalidated selected=0 selectedThread=thread-b");
		assertNotContains(report.finalSnapshot, "preview: user: inspect reload");
		assertNotContains(report.finalSnapshot, "preview: assistant: preview survives same thread");
		assertContains(report.summary(), "loaded-preview:query=preview;rows=3;selected=0;thread=thread-a;expanded=thread-a;preview=loaded;previewRendered=true;previewLines=2;pending=thread-a;transcript=preview_loaded");
		assertContains(report.summary(), "preserved:query=preview;rows=3;selected=1;thread=thread-a;expanded=thread-a;preview=loaded;previewRendered=true;previewLines=2;pending=thread-a;transcript=preview_loaded");
		assertContains(report.summary(), "invalidated:query=preview;rows=2;selected=0;thread=thread-b;expanded=<empty>;preview=<empty>;previewRendered=false;previewLines=0;pending=<empty>;transcript=<empty>");
		assertContains(report.summary(), "kind=preview_loaded;request=preview-thread-a;thread=thread-a");
		assertContains(report.summary(), "request=preserve-preview-page");
		assertContains(report.summary(), "request=invalidate-preview-page");

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
}
