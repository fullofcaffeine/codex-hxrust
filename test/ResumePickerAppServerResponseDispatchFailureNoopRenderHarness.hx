import codexhx.runtime.tui.resume.live.DispatchFailureNoopGate;

class ResumePickerAppServerResponseDispatchFailureNoopRenderHarness {
	static function main():Void {
		final report = DispatchFailureNoopGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.missingSessionNoopRecorded, "missing app-server session should become a no-op command");
		assertTrue(report.malformedIntentSerializationRefused, "missing response intent should be serialization-refused");
		assertTrue(report.unknownIntentSerializationRefused, "unknown response intent should be serialization-refused");
		assertTrue(report.missingPayloadSerializationRefused, "resolved intent without payload should be serialization-refused");
		assertTrue(report.sendFailureRecorded, "transport send failure should be recorded as a typed command");
		assertTrue(report.requestIdsPreserved, "request ids should survive failure/noop dispatch");
		assertTrue(report.noPressureDropRejection, "failure/noop dispatch should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after failure/noop dispatch");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("7", Std.string(report.frameRequests), "frame requests");
		assertEquals("7", Std.string(report.renderCount), "render count");
		assertEquals("7", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=response_dispatch_missing_session_noop");
		assertContains(snapshots[1], "command=missing_session_noop");
		assertContains(snapshots[2], "loader status=response_dispatch_malformed_intent_refused");
		assertContains(snapshots[2], "error=missing_response_intent:missing app-server response intent");
		assertContains(snapshots[3], "loader status=response_dispatch_unknown_intent_refused");
		assertContains(snapshots[3], "error=unknown_response_intent:unknown app-server response intent");
		assertContains(snapshots[4], "loader status=response_dispatch_missing_payload_refused");
		assertContains(snapshots[4], "error=missing_response_payload:resolved app-server request has no response payload");
		assertContains(snapshots[5], "loader status=response_dispatch_send_failed");
		assertContains(snapshots[5], "error code=transport_send_failed");
		assertContains(snapshots[5], "command=send_failed");
		assertContains(report.finalSnapshot,
			"> Response dispatch failure row A | thread-failure-a | turns=2 | 2026-06-20T04:40:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "kind=missing_session_noop;request=server-request-dispatch-missing-session-1");
		assertContains(report.summary(), "kind=serialization_refused;request=;intent=unknown;order=1");
		assertContains(report.summary(), "kind=serialization_refused;request=server-request-dispatch-unknown-intent-2");
		assertContains(report.summary(), "kind=serialization_refused;request=server-request-dispatch-missing-payload-3");
		assertContains(report.summary(), "kind=send_failed;request=server-request-dispatch-send-failed-4");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"dispatch failure\"");

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
