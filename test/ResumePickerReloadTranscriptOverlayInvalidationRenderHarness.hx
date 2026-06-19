import codexhx.runtime.tui.resume.live.ResumePickerReloadTranscriptOverlayInvalidationRenderGate;

class ResumePickerReloadTranscriptOverlayInvalidationRenderHarness {
	static function main():Void {
		final report = ResumePickerReloadTranscriptOverlayInvalidationRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("3", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.transcriptLoads), "transcript loads");
		assertEquals("1", Std.string(report.preservedOverlays), "preserved overlays");
		assertEquals("1", Std.string(report.invalidatedOverlays), "invalidated overlays");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "> Overlay anchor | thread-a | turns=3 | 2026-06-19T19:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[0], "overlay transcript thread=thread-a cells=3");
		assertContains(snapshots[0], "transcript: user: inspect overlay");
		assertContains(snapshots[0], "transcript: assistant: overlay survives same thread");
		assertContains(snapshots[0], "footer overlay loaded selected=0 selectedThread=thread-a");
		assertContains(snapshots[1], "rows loaded=3 filtered=3 scanned=4 accepted=3 invalid=1");
		assertContains(snapshots[1], "> Overlay anchor | thread-a | turns=3 | 2026-06-19T19:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[1], "overlay transcript thread=thread-a cells=3");
		assertContains(snapshots[1],
			"loader status=transcript_overlay_preserved_for_selected_thread detail=selected=thread-a;index=1;pending=thread-a;cells=3");
		assertContains(snapshots[1], "footer overlay preserved selected=1 selectedThread=thread-a");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0");
		assertContains(report.finalSnapshot, "> Replacement overlay target | thread-b | turns=5 | 2026-06-19T19:05:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "overlay closed");
		assertContains(report.finalSnapshot,
			"loader status=transcript_overlay_invalidated_after_selection_change detail=missing=thread-a;selected=thread-b;pendingCleared=true;overlayClosed=true;cells=0");
		assertContains(report.finalSnapshot, "footer overlay invalidated selected=0 selectedThread=thread-b");
		assertNotContains(report.finalSnapshot, "overlay transcript thread=thread-a");
		assertNotContains(report.finalSnapshot, "transcript: user: inspect overlay");
		assertContains(report.summary(),
			"loaded-overlay:query=overlay;rows=3;selected=0;thread=thread-a;pending=thread-a;transcript=loaded;overlayOpen=true;overlayCloseCount=0;cells=3");
		assertContains(report.summary(),
			"preserved:query=overlay;rows=3;selected=1;thread=thread-a;pending=thread-a;transcript=loaded;overlayOpen=true;overlayCloseCount=0;cells=3");
		assertContains(report.summary(),
			"invalidated:query=overlay;rows=2;selected=0;thread=thread-b;pending=<empty>;transcript=<empty>;overlayOpen=false;overlayCloseCount=1;cells=0");
		assertContains(report.summary(), "kind=transcript_loaded;request=transcript-thread-a;thread=thread-a");
		assertContains(report.summary(), "request=preserve-overlay-page");
		assertContains(report.summary(), "request=invalidate-overlay-page");

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
