import codexhx.runtime.tui.resume.live.ResumePickerSortFilterReloadRenderGate;

class ResumePickerSortFilterReloadRenderHarness {
	static function main():Void {
		final report = ResumePickerSortFilterReloadRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.sortFilterReloads), "sort/filter reloads");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "toolbar sort=updated_at filter=cwd query=kernel");
		assertContains(snapshots[0], "toolbar-detail focus=sort mode=expanded");
		assertContains(snapshots[0], "page next=cursor-query-next moreBelow=true loadingOlder=false scanCap=false nextPresent=true");
		assertContains(snapshots[0], "footer cwd query 3/3 selected=1 selectedThread=thread-cwd");
		assertContains(snapshots[1], "toolbar sort=created_at filter=all query=kernel");
		assertContains(snapshots[1], "toolbar-detail focus=filter mode=expanded");
		assertContains(snapshots[1], "rows loaded=0 filtered=0 scanned=0 accepted=0 invalid=0");
		assertContains(snapshots[1], "empty: Reloading saved chats...");
		assertContains(snapshots[1], "loader status=sort_filter_reload_requested detail=sort=created_at;filter=all;query=kernel;showAll=true;cursor=<empty>");
		assertContains(snapshots[1], "footer reloading sort/filter selected=0 selectedThread=<empty>");
		assertContains(report.finalSnapshot, "toolbar sort=created_at filter=all query=kernel");
		assertContains(report.finalSnapshot, "toolbar-detail focus=filter mode=compact");
		assertContains(report.finalSnapshot, "rows loaded=3 filtered=3 scanned=4 accepted=3 invalid=1");
		assertContains(report.finalSnapshot, "> Archived kernel match | thread-archived | turns=2 | 2026-06-18T15:00:00Z | cwd=/archive/codex-hxrust");
		assertContains(report.finalSnapshot, "  Remote kernel result | thread-remote | turns=13 | 2026-06-19T15:15:00Z | cwd=/remote/workspace");
		assertContains(report.finalSnapshot, "loader status=sort_filter_results_loaded detail=sort=created_at;filter=all;query=kernel;rows=3;invalid=1");
		assertContains(report.finalSnapshot, "footer all results 3/4 selected=0 selectedThread=thread-archived");
		assertContains(report.summary(), "id=initial-query-page;cursor=cursor-query;query=kernel;pageSize=3;sort=updated_at;filter=cwd;cwd=/workspace/codex-hxrust;showAll=false;includeNonInteractive=false");
		assertContains(report.summary(), "id=sort-filter-page;cursor=;query=kernel;pageSize=3;sort=created_at;filter=all;cwd=/workspace/codex-hxrust;showAll=true;includeNonInteractive=false");
		assertContains(report.summary(), "request=sort-filter-page");
		assertContains(report.summary(), "rows=3;next=;scanned=4;accepted=3;invalid=1");

		Sys.println(report.summary());
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0) throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual) throw label + " expected " + expected + " but got " + actual;
	}
}
