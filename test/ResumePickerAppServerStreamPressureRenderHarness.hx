import codexhx.validation.tui.resume.live.AppServerStreamPressureGate;

class ResumePickerAppServerStreamPressureRenderHarness {
	static function main():Void {
		final report = AppServerStreamPressureGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.pressureContractModeled, "stream pressure contract should be modeled");
		assertTrue(report.bestEffortDropped, "best-effort event should drop under pressure");
		assertTrue(report.serverRequestRejected, "dropped server request should be rejected");
		assertTrue(report.losslessBackpressured, "lossless event should backpressure under a full queue");
		assertTrue(report.losslessLagFlushed, "lossless follow-up should flush lag evidence");
		assertTrue(report.losslessEventPreserved, "lossless read event should survive pressure");
		assertTrue(report.recoveryDecoded, "page recovery should decode after pressure");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("1", Std.string(report.readRequests), "read requests");
		assertEquals("5", Std.string(report.frameRequests), "frame requests");
		assertEquals("6", Std.string(report.renderCount), "render count");
		assertEquals("6", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=stream_pressure_frame_requested detail=reason=pressure-frame-1");
		assertContains(snapshots[2], "loader status=stream_pressure_progress_seen detail=detail=cosmetic-progress");
		assertContains(snapshots[3], "error code=app_server_stream_lagged message=skipped=1");
		assertContains(snapshots[4], "preview: user: stream pressure");
		assertContains(snapshots[4], "preview: assistant: lossless survived");
		assertContains(report.finalSnapshot,
			"> Stream pressure pressure row A | thread-pressure-a | turns=2 | 2026-06-19T23:40:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "kind=frame_requested");
		assertContains(report.summary(), "kind=progress_updated");
		assertContains(report.summary(), "kind=server_request");
		assertContains(report.summary(), "best_effort_dropped");
		assertContains(report.summary(), "lossless_backpressure");
		assertContains(report.summary(), "read-lossless-blocked=kind=backpressured");
		assertContains(report.summary(), "forward:server-request-rejected:request=pressure-server-request-dropped");
		assertContains(report.summary(), "forward:lag:generation=1;kind=lagged");
		assertContains(report.summary(), "dispatch:active");
		assertContains(report.summary(), "kind=lagged");
		assertContains(report.summary(), "kind=read_result");
		assertContains(report.summary(), "kind=page_result");
		assertContains(report.summary(), "jsonMethod=thread/read;jsonParams=");
		assertContains(report.summary(), "\"threadId\":\"thread-pressure-a\"");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"pressure\"");

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
