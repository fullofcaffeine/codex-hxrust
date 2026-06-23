import codexhx.runtime.tui.resume.live.TypedPendingRequestRegistryGate;

class ResumePickerAppServerTypedPendingRequestRegistryRenderHarness {
	static function main():Void {
		final report = TypedPendingRequestRegistryGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.typedClassesRegistered, "typed request classes should register");
		assertTrue(report.keyDuplicateRejected, "duplicate request key should be rejected");
		assertTrue(report.userInputFifoResolved, "same-turn user input should resolve FIFO");
		assertTrue(report.mcpRequestMatched, "MCP request should match by server/request id");
		assertTrue(report.unsupportedRefused, "unsupported request class should be refused");
		assertTrue(report.notificationRemoved, "serverRequest/resolved notification should remove pending request");
		assertTrue(report.staleReplaySkipped, "stale replay should skip non-pending request");
		assertTrue(report.registryEmptyAtEnd, "registry should be empty at end");
		assertTrue(report.noPressureDropRejection, "typed registry refusals should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after typed registry lifecycle");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("8", Std.string(report.frameRequests), "frame requests");
		assertEquals("8", Std.string(report.renderCount), "render count");
		assertEquals("8", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=typed_pending_duplicate_key_rejected");
		assertContains(snapshots[1], "kind=duplicate_rejected;class=permissions_approval;request=typed-permissions-duplicate-3b;key=perm-1");
		assertContains(snapshots[2], "loader status=typed_pending_user_input_fifo_popped");
		assertContains(snapshots[2], "kind=user_input_fifo_popped;class=user_input;request=typed-user-input-5");
		assertContains(snapshots[3], "loader status=typed_pending_mcp_matched");
		assertContains(snapshots[3], "kind=mcp_matched;class=mcp_elicitation;request=typed-mcp-app-6");
		assertContains(snapshots[4], "loader status=typed_pending_unsupported_refused");
		assertContains(snapshots[4], "kind=unsupported_refused;class=dynamic_tool_call");
		assertContains(snapshots[5], "loader status=typed_pending_notification_removed");
		assertContains(snapshots[5], "kind=notification_removed;class=file_change_approval;request=typed-file-2");
		assertContains(snapshots[6], "loader status=typed_pending_stale_replay_skipped");
		assertContains(snapshots[7], "loader status=typed_pending_recovery_page_decoded");
		assertContains(report.finalSnapshot, "> Typed pending typed row A | thread-typed-a | turns=2 | 2026-06-20T05:30:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "kind=registered;class=exec_approval;request=typed-exec-1;key=approval-1");
		assertContains(report.summary(), "kind=registered;class=file_change_approval;request=typed-file-2;key=patch-1");
		assertContains(report.summary(), "kind=registered;class=permissions_approval;request=typed-permissions-3;key=perm-1");
		assertContains(report.summary(), "kind=user_input_fifo_popped;class=user_input;request=typed-user-input-4");
		assertContains(report.summary(), "kind=user_input_fifo_popped;class=user_input;request=typed-user-input-5");
		assertContains(report.summary(), "kind=mcp_matched;class=mcp_elicitation;request=typed-mcp-app-6");
		assertContains(report.summary(), "kind=unsupported_refused;class=dynamic_tool_call;request=typed-dynamic-7");
		assertContains(report.summary(), "kind=notification_removed;class=file_change_approval;request=typed-file-2");
		assertContains(report.summary(), "kind=stale_replay_skipped;class=unknown;request=typed-file-2");
		assertContains(report.summary(), "pending=[]");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertContains(report.summary(), "\"searchTerm\":\"typed pending\"");

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
