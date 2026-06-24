import codexhx.validation.tui.resume.live.NoResultsRecoveryGate;

class ResumePickerNoResultsReloadRecoveryRenderHarness {
	static function main():Void {
		final report = NoResultsRecoveryGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("3", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.emptyReloads), "empty reloads");
		assertEquals("1", Std.string(report.recoveryReloads), "recovery reloads");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "toolbar sort=created_at filter=all query=kernel");
		assertContains(snapshots[0], "> Archived kernel match | thread-archived | turns=2 | 2026-06-18T15:00:00Z | cwd=/archive/codex-hxrust");
		assertContains(snapshots[1], "toolbar sort=created_at filter=all query=zz-no-results");
		assertContains(snapshots[1], "rows loaded=0 filtered=0 scanned=5 accepted=0 invalid=0");
		assertContains(snapshots[1], "empty: No sessions match zz-no-results");
		assertContains(snapshots[1], "loader status=current_empty_results_loaded detail=query=zz-no-results;rows=0;scanned=5");
		assertContains(snapshots[1], "footer no results selected=0 selectedThread=<empty>");
		assertNotContains(snapshots[1], "Archived kernel match");
		assertContains(report.finalSnapshot, "toolbar sort=created_at filter=all query=kernel");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0");
		assertContains(report.finalSnapshot, "  Resume kernel | thread-kernel | turns=3 | 2026-06-19T15:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "> Kernel tool calls | thread-kernel-tools | turns=13 | 2026-06-19T15:20:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "loader status=recovery_results_loaded detail=query=kernel;rows=2;previousEmpty=true");
		assertContains(report.finalSnapshot, "footer recovered results 2/2 selected=1 selectedThread=thread-kernel-tools");
		assertContains(report.summary(),
			"empty:query=zz-no-results;rows=0;filtered=0;selected=0;thread=;footer=no results;empty=No sessions match zz-no-results;loader=current_empty_results_loaded");
		assertContains(report.summary(),
			"recovery:query=kernel;rows=2;filtered=2;selected=1;thread=thread-kernel-tools;footer=recovered results 2/2;empty=;loader=recovery_results_loaded");
		assertContains(report.summary(), "request=empty-page");
		assertContains(report.summary(), "request=recovery-page");

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
