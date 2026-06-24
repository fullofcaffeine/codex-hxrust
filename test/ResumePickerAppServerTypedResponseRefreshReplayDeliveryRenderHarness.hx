import codexhx.validation.tui.resume.live.RefreshReplayDeliveryGate;

class ResumePickerAppServerTypedResponseRefreshReplayDeliveryRenderHarness {
	static function main():Void {
		final report = RefreshReplayDeliveryGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("15", Std.string(report.deliveryIntentCount), "delivery intents");
		assertTrue(report.pendingInteractiveReplayDelivered, "pending interactive replay deliveries should be recorded");
		assertTrue(report.sideParentStatusDelivered, "side-parent status deliveries should be recorded");
		assertTrue(report.activeThreadStatusDelivered, "active-thread status deliveries should be recorded");
		assertTrue(report.deliveryOrderPreserved, "delivery ordering should match refresh application order");
		assertTrue(report.ignoredApplicationsHaveNoDelivery, "ignored refresh applications should not create delivery intents");
		assertTrue(report.recoveryDecoded, "page recovery should decode after replay delivery");
		assertTrue(report.noPressureDropRejection, "replay delivery gate should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("17", Std.string(report.frameRequests), "frame requests");
		assertEquals("17", Std.string(report.renderCount), "render count");
		assertEquals("17", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=typed_response_refresh_replay_delivery_pending_interactive_replay");
		assertContains(snapshots[1], "deliverySequence=1;groupIndex=1;replayKind=thread_snapshot;promptKind=exec_approval");
		assertContains(snapshots[2], "loader status=typed_response_refresh_replay_delivery_side_parent_status");
		assertContains(snapshots[2], "sideParentStatus=true");
		assertContains(snapshots[3], "loader status=typed_response_refresh_replay_delivery_active_thread_status");
		assertContains(snapshots[3], "activeThreadStatus=true");
		assertContains(snapshots[10], "promptKind=request_user_input;sideStatusKind=needs_input");
		assertContains(snapshots[13], "promptKind=elicitation;sideStatusKind=needs_approval");
		assertContains(snapshots[16], "loader status=typed_response_refresh_replay_recovery_page_decoded");
		assertContains(report.finalSnapshot, "> Typed refresh replay row A | thread-replay-a | turns=2 | 2026-06-20T06:35:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "deliveryIntentCount=15");
		assertContains(report.summary(), "pendingInteractiveReplayDelivered=true");
		assertContains(report.summary(), "sideParentStatusDelivered=true");
		assertContains(report.summary(), "activeThreadStatusDelivered=true");
		assertContains(report.summary(), "ignoredApplicationsHaveNoDelivery=true");
		assertContains(report.summary(), "kind=pending_interactive_replay;class=exec_approval");
		assertContains(report.summary(), "kind=side_parent_status;class=mcp_elicitation");
		assertContains(report.summary(), "kind=active_thread_status;class=mcp_elicitation");
		assertContains(report.summary(), "delivery-skip:refresh_application_no_delivery;request=typed-replay-dynamic-6");
		assertContains(report.summary(), "delivery-skip:refresh_application_no_delivery;request=typed-replay-exec-1");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertNotContains(report.summary(), "kind=pending_interactive_replay;class=dynamic_tool_call");
		assertNotContains(report.summary(), "payloadKind=missing_pending_noop;request=;dispatchSequence=7;appliedIndex=0;deliverySequence");

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
