import codexhx.runtime.tui.resume.live.ResumePickerInvalidRowProjectionRenderGate;

class ResumePickerInvalidRowProjectionRenderHarness {
	static function main():Void {
		final report = ResumePickerInvalidRowProjectionRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("1", Std.string(report.pageLoads), "page loads");
		assertEquals("5", Std.string(report.scannedRows), "scanned rows");
		assertEquals("3", Std.string(report.acceptedRows), "accepted rows");
		assertEquals("2", Std.string(report.invalidRows), "invalid rows");
		assertEquals("2", Std.string(report.frameRequests), "frame requests");
		assertEquals("2", Std.string(report.renderCount), "render count");
		assertEquals("2", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "empty: Loading saved chats...");
		assertContains(report.finalSnapshot, "rows loaded=3 filtered=3 scanned=5 accepted=3 invalid=2");
		assertContains(report.finalSnapshot, "  Named thread | thread-named | turns=4 | 2026-06-19T12:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "> assistant: trimmed preview | thread-preview | turns=7 | 2026-06-19T12:10:00Z | cwd=/workspace/codex-hxrust/crates/codex");
		assertContains(report.finalSnapshot, "  (no message yet) | thread-empty | turns=0 | 2026-06-19T12:20:00Z | cwd=/tmp/empty-session");
		assertContains(report.finalSnapshot, "    preview: assistant: trimmed preview");
		assertContains(report.finalSnapshot, "    preview: (no message yet)");
		assertContains(report.finalSnapshot, "loader status=invalid_rows_skipped detail=invalid=2;accepted=3;scanned=5");
		assertContains(report.finalSnapshot, "footer accepted 3/5 selected=1 selectedThread=thread-preview");
		assertContains(report.summary(), "kind=page_loaded;request=projection-page");
		assertContains(report.summary(), "scanned=5;accepted=3;invalid=2");

		Sys.println(report.summary());
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0) throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual) throw label + " expected " + expected + " but got " + actual;
	}
}
