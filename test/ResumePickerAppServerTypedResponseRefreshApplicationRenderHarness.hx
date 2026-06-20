import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRefreshApplicationRenderGate;

class ResumePickerAppServerTypedResponseRefreshApplicationRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRefreshApplicationRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.supportedRefreshApplied, "supported response refreshes should apply");
		assertTrue(report.refreshOrderPreserved, "refresh application order should match dispatch order");
		assertTrue(report.noRefreshPathsIgnored, "reject/noop/duplicate paths should not mutate refresh state");
		assertTrue(report.refreshCountsMatch, "refresh counters should match applied response count");
		assertTrue(report.recoveryDecoded, "page recovery should decode after refresh application");
		assertTrue(report.noPressureDropRejection, "refresh application gate should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("10", Std.string(report.frameRequests), "frame requests");
		assertEquals("10", Std.string(report.renderCount), "render count");
		assertEquals("10", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=typed_response_refresh_applied");
		assertContains(snapshots[1], "appliedIndex=1;pendingReplay=true;sideParentStatus=true;activeThreadStatus=true");
		assertContains(snapshots[5], "class=mcp_elicitation");
		assertContains(snapshots[5], "pendingReplayCount=5;sideParentStatusCount=5;activeThreadStatusCount=5");
		assertContains(snapshots[6], "loader status=typed_response_refresh_ignored_no_refresh");
		assertContains(snapshots[6], "mutation=false;reason=no_refresh_mutation");
		assertContains(snapshots[8], "request=typed-refresh-exec-1;dispatchSequence=8;appliedIndex=0");
		assertContains(snapshots[9], "loader status=typed_response_refresh_recovery_page_decoded");
		assertContains(report.finalSnapshot, "> Typed refresh refresh row A | thread-refresh-a | turns=2 | 2026-06-20T06:25:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "supportedRefreshApplied=true");
		assertContains(report.summary(), "refreshOrderPreserved=true");
		assertContains(report.summary(), "refreshCountsMatch=true");
		assertContains(report.summary(), "kind=applied;class=exec_approval");
		assertContains(report.summary(), "kind=applied;class=mcp_elicitation");
		assertContains(report.summary(), "kind=ignored_no_refresh;class=dynamic_tool_call");
		assertContains(report.summary(), "kind=ignored_no_refresh;class=exec_approval");
		assertContains(report.summary(), "pendingReplayCount=5");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");

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
