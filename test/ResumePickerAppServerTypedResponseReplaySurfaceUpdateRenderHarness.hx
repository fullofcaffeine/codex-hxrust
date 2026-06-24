import codexhx.validation.tui.resume.live.ReplaySurfaceUpdateGate;

class ResumePickerAppServerTypedResponseReplaySurfaceUpdateRenderHarness {
	static function main():Void {
		final report = ReplaySurfaceUpdateGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("15", Std.string(report.surfaceUpdateCount), "surface updates");
		assertTrue(report.pendingInteractiveSurfaceUpdated, "pending interactive surfaces should update");
		assertTrue(report.sideParentSurfaceUpdated, "side-parent surfaces should update");
		assertTrue(report.activeThreadSurfaceUpdated, "active-thread surfaces should update");
		assertTrue(report.surfaceOrderPreserved, "surface ordering should follow delivery ordering");
		assertTrue(report.ignoredApplicationsAbsentFromSurfaces, "ignored refresh applications should not reach surfaces");
		assertTrue(report.recoveryDecoded, "page recovery should decode after surface updates");
		assertTrue(report.noPressureDropRejection, "surface update gate should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("17", Std.string(report.frameRequests), "frame requests");
		assertEquals("17", Std.string(report.renderCount), "render count");
		assertEquals("17", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=typed_response_replay_surface_pending_interactive_prompt");
		assertContains(snapshots[1], "surfaceSequence=1;replayKind=thread_snapshot;promptKind=exec_approval");
		assertContains(snapshots[2], "loader status=typed_response_replay_surface_side_parent_status");
		assertContains(snapshots[2], "label=side parent needs_approval");
		assertContains(snapshots[3], "loader status=typed_response_replay_surface_active_thread_status");
		assertContains(snapshots[3], "activeThreadSurface=true");
		assertContains(snapshots[10], "promptKind=request_user_input;sideStatusKind=needs_input");
		assertContains(snapshots[10], "label=pending interactive request_user_input");
		assertContains(snapshots[13], "promptKind=elicitation;sideStatusKind=needs_approval");
		assertContains(snapshots[16], "loader status=typed_response_replay_surface_recovery_page_decoded");
		assertContains(report.finalSnapshot, "> Typed surface surface row A | thread-surface-a | turns=2 | 2026-06-20T06:55:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "surfaceUpdateCount=15");
		assertContains(report.summary(), "pendingInteractiveSurfaceUpdated=true");
		assertContains(report.summary(), "sideParentSurfaceUpdated=true");
		assertContains(report.summary(), "activeThreadSurfaceUpdated=true");
		assertContains(report.summary(), "ignoredApplicationsAbsentFromSurfaces=true");
		assertContains(report.summary(), "kind=pending_interactive_prompt;class=exec_approval");
		assertContains(report.summary(), "kind=side_parent_status;class=mcp_elicitation");
		assertContains(report.summary(), "kind=active_thread_status;class=mcp_elicitation");
		assertContains(report.summary(), "delivery-skip:refresh_application_no_delivery;request=typed-surface-dynamic-6");
		assertContains(report.summary(), "delivery-skip:refresh_application_no_delivery;request=typed-surface-exec-1");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertNotContains(report.summary(), "kind=pending_interactive_prompt;class=dynamic_tool_call");
		assertNotContains(report.summary(), "payloadKind=missing_pending_noop;request=;deliverySequence");

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
