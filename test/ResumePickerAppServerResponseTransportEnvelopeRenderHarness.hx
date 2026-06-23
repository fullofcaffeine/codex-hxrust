import codexhx.runtime.tui.resume.live.ResponseTransportEnvelopeGate;

class ResponseTransportEnvelopeRenderHarness {
	static function main():Void {
		final report = ResponseTransportEnvelopeGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.resolveEnvelopeRecorded, "resolve command should produce result envelope");
		assertTrue(report.rejectEnvelopeRecorded, "reject command should produce error envelope");
		assertTrue(report.localRefusalEnvelopeRecorded, "serialization refusal should stay local");
		assertTrue(report.sendFailureEnvelopeRecorded, "send failure should be recorded as envelope");
		assertTrue(report.requestIdsCorrelated, "request ids should be correlated in envelopes");
		assertTrue(report.errorPayloadsDistinct, "error payloads should preserve distinct failure codes");
		assertTrue(report.noPressureDropRejection, "transport envelope should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after response envelope records");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("6", Std.string(report.frameRequests), "frame requests");
		assertEquals("6", Std.string(report.renderCount), "render count");
		assertEquals("6", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=response_transport_resolve_envelope");
		assertContains(snapshots[1], "kind=resolve_result;method=resolve_server_request");
		assertContains(snapshots[2], "loader status=response_transport_reject_envelope");
		assertContains(snapshots[2], "kind=reject_error;method=reject_server_request");
		assertContains(snapshots[3], "loader status=response_transport_local_refusal_envelope");
		assertContains(snapshots[3], "kind=local_serialization_refusal;method=serverRequest/localRefusal");
		assertContains(snapshots[4], "loader status=response_transport_send_failure_envelope");
		assertContains(snapshots[4], "kind=send_failure;method=reject_server_request");
		assertContains(report.finalSnapshot,
			"> Response transport transport row A | thread-transport-a | turns=2 | 2026-06-20T04:50:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "\"result\":{\"answer\":\"continue\"}");
		assertContains(report.summary(), "\"error\":{\"code\":\"unsupported_in_fixture\"");
		assertContains(report.summary(), "\"error\":{\"code\":\"missing_response_payload\"");
		assertContains(report.summary(), "\"error\":{\"code\":\"transport_send_failed\"");
		assertContains(report.summary(), "correlation=server:server-request-envelope-resolve-1");
		assertContains(report.summary(), "correlation=server:server-request-envelope-reject-2");
		assertContains(report.summary(), "correlation=server:server-request-envelope-local-refusal-3");
		assertContains(report.summary(), "correlation=server:server-request-envelope-send-failed-4");
		assertContains(report.summary(), "localOnly=true;sendIntent=false");
		assertContains(report.summary(), "sendIntent=true;liveTransport=false;suppressed=true");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertContains(report.summary(), "\"searchTerm\":\"transport envelope\"");

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
