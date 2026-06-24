import codexhx.validation.tui.resume.live.FailurePreservationGate;

class ResumePickerReloadFailurePreservationRenderHarness {
	static function main():Void {
		final report = FailurePreservationGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.reloadFailures), "reload failures");
		assertEquals("1", Std.string(report.recoveryReloads), "recovery reloads");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "toolbar sort=updated_at filter=all query=kernel");
		assertContains(snapshots[0], "> Stable failure row | thread-stable | turns=5 | 2026-06-19T20:05:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[0], "footer active results 3/3 selected=1 selectedThread=thread-stable");
		assertContains(snapshots[1], "toolbar sort=updated_at filter=all query=kernel");
		assertContains(snapshots[1], "rows loaded=3 filtered=3 scanned=3 accepted=3 invalid=0");
		assertContains(snapshots[1], "> Stable failure row | thread-stable | turns=5 | 2026-06-19T20:05:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[1], "error code=missing_page_fixture message=no page response for missing-reload-page");
		assertContains(snapshots[1],
			"loader status=reload_failed_preserved_previous_results detail=request=missing-reload-page;code=missing_page_fixture;preservedThread=thread-stable;rows=3");
		assertContains(snapshots[1], "footer reload failed selected=1 selectedThread=thread-stable");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0");
		assertContains(report.finalSnapshot, "> Recovered failure row | thread-recovered | turns=13 | 2026-06-19T20:15:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot,
			"loader status=reload_recovered_after_failure detail=request=recovery-after-failure-page;previousFailure=true;rows=2");
		assertContains(report.finalSnapshot, "footer reload recovered selected=0 selectedThread=thread-recovered");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(),
			"failure:query=kernel;rows=3;filtered=3;selected=1;thread=thread-stable;scrollTop=0;errorShown=true;failure=missing_page_fixture;footer=reload failed;loader=reload_failed_preserved_previous_results");
		assertContains(report.summary(),
			"recovery:query=kernel;rows=2;filtered=2;selected=0;thread=thread-recovered;scrollTop=0;errorShown=false;failure=<empty>;footer=reload recovered;loader=reload_recovered_after_failure");
		assertContains(report.summary(), "kind=failed;request=missing-reload-page");
		assertContains(report.summary(), "failure=missing_page_fixture:no page response for missing-reload-page");
		assertContains(report.summary(), "request=recovery-after-failure-page");

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
