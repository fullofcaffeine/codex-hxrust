import codexhx.runtime.tui.resume.live.ResumePickerStaleReloadResponseRenderGate;

class ResumePickerStaleReloadResponseRenderHarness {
	static function main():Void {
		final report = ResumePickerStaleReloadResponseRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("1", Std.string(report.activePageLoads), "active page loads");
		assertEquals("2", Std.string(report.stalePageRefusals), "stale page refusals");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(report.activeSnapshot, "toolbar sort=created_at filter=all query=kernel");
		assertContains(report.activeSnapshot, "> Archived kernel match | thread-archived | turns=2 | 2026-06-18T15:00:00Z | cwd=/archive/codex-hxrust");
		assertContains(snapshots[1], "loader status=stale_query_response_ignored detail=request=stale-query-page;activeQuery=kernel;activeSort=created_at;activeFilter=all");
		assertContains(snapshots[2], "loader status=stale_sort_response_ignored detail=request=stale-sort-page;activeQuery=kernel;activeSort=created_at;activeFilter=all");
		assertContains(report.finalSnapshot, "toolbar sort=created_at filter=all query=kernel");
		assertContains(report.finalSnapshot, "rows loaded=3 filtered=3 scanned=4 accepted=3 invalid=1");
		assertContains(report.finalSnapshot, "> Archived kernel match | thread-archived | turns=2 | 2026-06-18T15:00:00Z | cwd=/archive/codex-hxrust");
		assertContains(report.finalSnapshot, "  Resume kernel | thread-kernel | turns=3 | 2026-06-19T15:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "  Remote kernel result | thread-remote | turns=13 | 2026-06-19T15:15:00Z | cwd=/remote/workspace");
		assertContains(report.finalSnapshot, "footer stale response ignored selected=0 selectedThread=thread-archived");
		assertNotContains(report.finalSnapshot, "Stale host result");
		assertNotContains(report.finalSnapshot, "Stale cwd result");
		assertNotContains(report.finalSnapshot, "stale-query-cursor");
		assertNotContains(report.finalSnapshot, "stale-sort-cursor");
		assertContains(report.summary(), "active:query=kernel;sort=created_at;filter=all;selected=0;thread=thread-archived;next=;rows=3;footer=active all results 3/4;loader=active_results_loaded");
		assertContains(report.summary(), "stale-query:query=kernel;sort=created_at;filter=all;selected=0;thread=thread-archived;next=;rows=3;footer=stale response ignored;loader=stale_query_response_ignored");
		assertContains(report.summary(), "stale-sort:query=kernel;sort=created_at;filter=all;selected=0;thread=thread-archived;next=;rows=3;footer=stale response ignored;loader=stale_sort_response_ignored");
		assertContains(report.summary(), "request=stale-query-page");
		assertContains(report.summary(), "request=stale-sort-page");

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
