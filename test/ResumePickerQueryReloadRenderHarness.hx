import codexhx.runtime.tui.resume.live.ResumePickerQueryReloadRenderGate;

class ResumePickerQueryReloadRenderHarness {
	static function main():Void {
		final report = ResumePickerQueryReloadRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.queryReloads), "query reloads");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "toolbar sort=updated_at filter=cwd query=<empty>");
		assertContains(snapshots[0], "page next=cursor-before-query moreBelow=true loadingOlder=false scanCap=false nextPresent=true");
		assertContains(snapshots[0], "footer initial 3/3 selected=1 selectedThread=thread-host");
		assertContains(snapshots[1], "toolbar sort=updated_at filter=cwd query=kernel");
		assertContains(snapshots[1], "rows loaded=0 filtered=0 scanned=0 accepted=0 invalid=0");
		assertContains(snapshots[1], "empty: Searching saved chats...");
		assertContains(snapshots[1], "loader status=query_reload_requested detail=query=kernel;cursor=<empty>;reset=true");
		assertContains(snapshots[1], "footer loading query selected=0 selectedThread=<empty>");
		assertContains(report.finalSnapshot, "toolbar sort=updated_at filter=cwd query=kernel");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0");
		assertContains(report.finalSnapshot, "> Resume kernel | thread-kernel | turns=3 | 2026-06-19T14:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "  Kernel tool calls | thread-kernel-tools | turns=13 | 2026-06-19T14:15:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "loader status=query_results_loaded detail=query=kernel;rows=2;cursor=<empty>");
		assertContains(report.finalSnapshot, "footer query ready 2/2 selected=0 selectedThread=thread-kernel");
		assertContains(report.summary(), "id=initial-page;cursor=;query=;pageSize=3");
		assertContains(report.summary(), "id=query-page;cursor=;query=kernel;pageSize=3");
		assertContains(report.summary(), "request=query-page");
		assertContains(report.summary(), "rows=2;next=;scanned=2;accepted=2");

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
