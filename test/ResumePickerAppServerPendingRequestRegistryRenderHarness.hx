import codexhx.validation.tui.resume.live.AppServerPendingRequestRegistryGate;

class ResumePickerAppServerPendingRequestRegistryRenderHarness {
	static function main():Void {
		final report = AppServerPendingRequestRegistryGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.registrationRecorded, "delivered server request should register as pending");
		assertTrue(report.duplicateRejected, "duplicate request id should be refused");
		assertTrue(report.resolveRemovedPending, "resolve response should remove pending request");
		assertTrue(report.rejectRemovedPending, "reject response should remove pending request");
		assertTrue(report.secondResponseRefused, "second response for removed request should be refused");
		assertTrue(report.abandonedCleanupRecorded, "abandoned pending request should be cleaned up");
		assertTrue(report.registryEmptyAtEnd, "registry should be empty at end of gate");
		assertTrue(report.noPressureDropRejection, "registry refusal should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after registry lifecycle");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("8", Std.string(report.frameRequests), "frame requests");
		assertEquals("8", Std.string(report.renderCount), "render count");
		assertEquals("8", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=pending_registry_registered");
		assertContains(snapshots[1], "kind=registered;order=1;before=0;after=1");
		assertContains(snapshots[2], "loader status=pending_registry_duplicate_rejected");
		assertContains(snapshots[2], "kind=duplicate_rejected;order=1;before=1;after=1;reason=duplicate_request_id");
		assertContains(snapshots[3], "loader status=pending_registry_resolved_removed");
		assertContains(snapshots[3], "registry=resolved_removed;before=1;after=0;envelope=resolve_result");
		assertContains(snapshots[4], "loader status=pending_registry_second_response_refused");
		assertContains(snapshots[4], "kind=late_response_refused;order=0;before=0;after=0;reason=request_not_pending");
		assertContains(snapshots[5], "loader status=pending_registry_rejected_removed");
		assertContains(snapshots[5], "registry=rejected_removed;before=1;after=0;envelope=reject_error");
		assertContains(snapshots[6], "loader status=pending_registry_abandoned_cleaned");
		assertContains(snapshots[6], "kind=abandoned_cleaned;order=3;before=1;after=0;reason=session_disconnected");
		assertContains(report.finalSnapshot,
			"> Pending registry registry row A | thread-registry-a | turns=2 | 2026-06-20T05:10:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "kind=registered;request=pending-registry-resolve-1;order=1");
		assertContains(report.summary(), "kind=duplicate_rejected;request=pending-registry-resolve-1;order=1");
		assertContains(report.summary(), "kind=resolved_removed;request=pending-registry-resolve-1;order=1");
		assertContains(report.summary(), "kind=late_response_refused;request=pending-registry-resolve-1;order=0");
		assertContains(report.summary(), "kind=rejected_removed;request=pending-registry-reject-2;order=2");
		assertContains(report.summary(), "kind=abandoned_cleaned;request=pending-registry-abandoned-3;order=3");
		assertContains(report.summary(), "envelopes=[kind=resolve_result");
		assertContains(report.summary(), "kind=reject_error");
		assertContains(report.summary(), "pending=[]");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertContains(report.summary(), "\"searchTerm\":\"pending registry\"");

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
