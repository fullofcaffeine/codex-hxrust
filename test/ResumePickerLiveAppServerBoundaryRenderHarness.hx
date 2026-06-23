import codexhx.runtime.tui.resume.live.AppServerBoundaryGate;

class ResumePickerLiveAppServerBoundaryRenderHarness {
	static function main():Void {
		final report = AppServerBoundaryGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.requestIdsPreserved, "request ids should be preserved across source, loader, and host events");
		assertTrue(report.requestFieldsPreserved, "thread/list request fields should include cursor/query/sort/filter/cwd policy");
		assertTrue(report.backpressureSeen, "bounded loader should report lossless backpressure for the reload request");
		assertTrue(report.errorMapped, "source failure should be mapped to app-server thread/list failure state");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("4", Std.string(report.pageRequests), "page request count");
		assertEquals("0", Std.string(report.pendingEvents), "final pending events");
		assertEquals("0", Std.string(report.skippedEvents), "skipped events");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0],
			"loader status=live_boundary_backpressure detail=request=live-blocked-reload-page;cursor=cursor-live-2;query=kernel;sort=created_at;filter=all;pending=1;skipped=0");
		assertContains(snapshots[0], "footer live reload queued selected=0 selectedThread=<empty>");
		assertContains(snapshots[1], "> Boundary active row | thread-boundary-a | turns=3 | 2026-06-19T21:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[1], "page next=cursor-live-2 moreBelow=true loadingOlder=false scanCap=false nextPresent=true");
		assertContains(snapshots[2], "error code=app_server_thread_list_failed message=missing_page_fixture:no page response for live-missing-page");
		assertContains(snapshots[2],
			"loader status=live_boundary_error_mapped detail=request=live-missing-page;sourceCode=missing_page_fixture;preservedThread=thread-boundary-a;rows=2");
		assertContains(report.finalSnapshot,
			"> Boundary recovered row | thread-boundary-recovered | turns=8 | 2026-06-19T21:10:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "loader status=live_boundary_recovered detail=request=live-recovery-page");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(),
			"id=live-blocked-reload-page;cursor=cursor-live-2;query=kernel;pageSize=2;sort=created_at;filter=all;cwd=/workspace/codex-hxrust;showAll=true;includeNonInteractive=true");
		assertContains(report.summary(), "blocked-reload:kind=backpressured");
		assertContains(report.summary(), "lossless_backpressure");
		assertContains(report.summary(), "kind=failed;request=live-missing-page");
		assertContains(report.summary(),
			"mapped-error:query=kernel;sort=created_at;filter=all;rows=2;selected=0;thread=thread-boundary-a;errorShown=true;failure=app_server_thread_list_failed");
		assertContains(report.summary(), "noCredentialOrModelTraffic=true;stateDbUntouched=true");

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

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
