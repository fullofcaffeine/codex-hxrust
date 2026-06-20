import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseDispatchOrderingRefreshRenderGate;

class ResumePickerAppServerTypedResponseDispatchOrderingRefreshRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseDispatchOrderingRefreshRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.responseOrderPreserved, "typed response dispatch should preserve envelope order");
		assertTrue(report.supportedRefreshScheduled, "supported typed responses should schedule refresh intent");
		assertTrue(report.unsupportedRejectNoRefresh, "unsupported reject should not schedule refresh");
		assertTrue(report.missingNoopNoRefresh, "missing pending no-op should not schedule refresh");
		assertTrue(report.lateDuplicateRefused, "late duplicate response should be refused");
		assertTrue(report.requestIdsCorrelated, "dispatch outcomes should preserve request correlation keys");
		assertTrue(report.noPressureDropRejection, "dispatch ordering gate should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after response dispatch ordering");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("10", Std.string(report.frameRequests), "frame requests");
		assertEquals("10", Std.string(report.renderCount), "render count");
		assertEquals("10", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=typed_response_dispatch_resolve_sent");
		assertContains(snapshots[1], "sequence=1;sourceOrder=1;refresh=true");
		assertContains(snapshots[5], "request=typed-dispatch-mcp-5");
		assertContains(snapshots[5], "sideParentStatus=true");
		assertContains(snapshots[6], "loader status=typed_response_dispatch_reject_sent");
		assertContains(snapshots[6], "refresh=false");
		assertContains(snapshots[7], "loader status=typed_response_dispatch_local_noop");
		assertContains(snapshots[7], "reason=local_noop_without_refresh");
		assertContains(snapshots[8], "loader status=typed_response_dispatch_late_duplicate_refused");
		assertContains(snapshots[8], "reason=request_already_dispatched");
		assertContains(snapshots[9], "loader status=typed_response_dispatch_recovery_page_decoded");
		assertContains(report.finalSnapshot,
			"> Typed dispatch dispatch row A | thread-dispatch-a | turns=2 | 2026-06-20T06:05:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "responseOrderPreserved=true");
		assertContains(report.summary(), "supportedRefreshScheduled=true");
		assertContains(report.summary(), "kind=resolve_sent;class=exec_approval");
		assertContains(report.summary(), "kind=resolve_sent;class=mcp_elicitation");
		assertContains(report.summary(), "kind=reject_sent;class=dynamic_tool_call");
		assertContains(report.summary(), "kind=local_noop;class=exec_approval");
		assertContains(report.summary(), "kind=late_duplicate_refused;class=exec_approval");
		assertContains(report.summary(), "correlation=server:typed-dispatch-exec-1");
		assertContains(report.summary(), "correlation=local:missing-request");
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
