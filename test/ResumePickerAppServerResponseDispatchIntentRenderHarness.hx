import codexhx.validation.tui.resume.live.AppServerResponseDispatchIntentGate;

class ResumePickerAppServerResponseDispatchIntentRenderHarness {
	static function main():Void {
		final report = AppServerResponseDispatchIntentGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.deliveredRequestsMatched, "delivered request ids should match response dispatch commands");
		assertTrue(report.dispatchCommandsTyped, "response dispatch commands should be typed");
		assertTrue(report.responseOrderingPreserved, "response dispatch ordering should be preserved");
		assertTrue(report.unsupportedRefusalDistinctFromPressureDrop, "unsupported refusal should not look like pressure-drop rejection");
		assertTrue(report.liveTransportSuppressed, "gate must record intent without live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after response dispatch intent");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=response_dispatch_refused");
		assertContains(snapshots[1], "command=reject_server_request;order=1;liveTransport=false;suppressed=true");
		assertContains(snapshots[2], "loader status=response_dispatch_resolved");
		assertContains(snapshots[2], "command=resolve_server_request;order=2;liveTransport=false;suppressed=true");
		assertNotContains(snapshots[1], "error code=");
		assertNotContains(snapshots[2], "error code=");
		assertContains(report.finalSnapshot,
			"> Response dispatch dispatch row A | thread-dispatch-a | turns=2 | 2026-06-20T04:30:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "kind=server_request_delivered");
		assertContains(report.summary(), "dispatchCommands=[kind=reject_server_request;request=server-request-dispatch-refused-1");
		assertContains(report.summary(), "kind=resolve_server_request;request=server-request-dispatch-resolved-2");
		assertContains(report.summary(), "error=unsupported_in_fixture:resume_picker_fixture_has_no_interactive_bottom_pane");
		assertContains(report.summary(), "response={\"answer\":\"continue\"}");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"dispatch\"");

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
