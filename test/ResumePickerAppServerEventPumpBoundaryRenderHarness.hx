import codexhx.runtime.tui.resume.live.ResumePickerAppServerEventPumpBoundaryRenderGate;

class ResumePickerAppServerEventPumpBoundaryRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerEventPumpBoundaryRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.eventPumpModeled, "event pump should model queued app-server stream events");
		assertTrue(report.eventConversionRouted, "active events should route through typed host events");
		assertTrue(report.staleGenerationFiltered, "stale generation events should be ignored deterministically");
		assertTrue(report.frameSchedulingRecorded, "frame scheduling intent should be recorded");
		assertTrue(report.disconnectPropagated, "disconnect events should propagate through the session boundary");
		assertTrue(report.recoveryDecoded, "fresh session generation should recover page rendering");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("2", Std.string(report.pageRequests), "page requests");
		assertEquals("1", Std.string(report.readRequests), "read requests");
		assertEquals("8", Std.string(report.frameRequests), "frame requests");
		assertEquals("8", Std.string(report.renderCount), "render count");
		assertEquals("8", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=event_pump_frame_requested detail=reason=stream-page-ready");
		assertContains(snapshots[2], "> Event pump pump row A | thread-pump-a | turns=2 | 2026-06-19T23:30:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[3], "error code=stale_app_server_event_ignored");
		assertContains(snapshots[4], "preview: user: event pump");
		assertContains(snapshots[4], "preview: assistant: preview active");
		assertContains(snapshots[5], "error code=app_server_stream_disconnected message=event pump disconnected;transport=disconnected");
		assertContains(snapshots[6], "error code=stale_app_server_event_ignored");
		assertContains(report.finalSnapshot, "> Event pump recovery row A | thread-recovery-a | turns=2 | 2026-06-19T23:30:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "session:attach:generation=1");
		assertContains(report.summary(), "session:attach:generation=2");
		assertContains(report.summary(), "kind=frame_requested");
		assertContains(report.summary(), "kind=page_result");
		assertContains(report.summary(), "kind=read_result");
		assertContains(report.summary(), "dispatch:stale");
		assertContains(report.summary(), "eventGeneration=0;activeGeneration=1");
		assertContains(report.summary(), "eventGeneration=1;activeGeneration=2");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"pump\"");
		assertContains(report.summary(), "jsonMethod=thread/read;jsonParams=");
		assertContains(report.summary(), "\"threadId\":\"thread-pump-a\"");
		assertContains(report.summary(), "session:disconnect:ok=true;code=disconnected");

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
