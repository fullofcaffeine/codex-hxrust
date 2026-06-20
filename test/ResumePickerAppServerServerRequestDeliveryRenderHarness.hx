import codexhx.runtime.tui.resume.live.ResumePickerAppServerServerRequestDeliveryRenderGate;

class ResumePickerAppServerServerRequestDeliveryRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerServerRequestDeliveryRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.serverRequestTyped, "server request event should remain typed");
		assertTrue(report.serverRequestDelivered, "server request should be delivered into host boundary");
		assertTrue(report.deliveryNotDropped, "accepted server request should not be recorded as a pressure drop");
		assertTrue(report.responseIntentRecorded, "fixture should record deterministic refusal intent");
		assertTrue(report.recoveryDecoded, "page recovery should decode after server request delivery");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=server_request_delivered detail=request=server-request-delivery-1;kind=server_request_delivered");
		assertContains(snapshots[1], "intent=refused;reason=resume_picker_fixture_has_no_interactive_bottom_pane");
		assertNotContains(snapshots[1], "error code=");
		assertContains(report.finalSnapshot,
			"> Server request delivery row A | thread-delivery-a | turns=2 | 2026-06-19T23:52:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "kind=server_request");
		assertContains(report.summary(), "kind=server_request_delivered");
		assertContains(report.summary(), "server-request=kind=ready");
		assertContains(report.summary(), "responseIntents=[kind=refused;request=server-request-delivery-1");
		assertContains(report.summary(), "failure=unsupported_in_fixture");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"delivery\"");

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
