import codexhx.runtime.tui.resume.live.AppServerSessionLifecycleGate;

class ResumePickerAppServerSessionLifecycleRenderHarness {
	static function main():Void {
		final report = AppServerSessionLifecycleGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.requestShapePreserved, "session lifecycle gate should preserve upstream JSON-RPC request shape");
		assertTrue(report.sessionLifecycleModeled, "session lifecycle should model enqueue, cancel, disconnect, refusal, and recovery");
		assertTrue(report.cancellationRouted, "pending page/read cancellation should route through typed host failures");
		assertTrue(report.lateResponseRejected, "late response after cancellation should be rejected deterministically");
		assertTrue(report.disconnectRefusalModeled, "new requests on a disconnected session should be refused");
		assertTrue(report.recoveryDecoded, "fresh session should recover page and transcript rendering");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("3", Std.string(report.pageRequests), "page requests");
		assertEquals("2", Std.string(report.readRequests), "read requests");
		assertEquals("7", Std.string(report.frameRequests), "frame requests");
		assertEquals("7", Std.string(report.renderCount), "render count");
		assertEquals("7", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "error code=app_server_session_cancelled message=session closed before preview response");
		assertContains(snapshots[2], "error code=json_rpc_response_rejected message=unknown_request_id:no pending request for response");
		assertContains(snapshots[3], "error code=app_server_session_cancelled message=session closed before page response");
		assertContains(snapshots[4], "error code=app_server_session_closed message=transport_closed:session stream disconnected");
		assertContains(snapshots[5], "> Recovered session row | thread-session-recovered | turns=2 | 2026-06-19T23:20:00Z | cwd=/workspace/codex-hxrust");
		assertContains(report.finalSnapshot, "overlay transcript thread=thread-session-recovered cells=3");
		assertContains(report.finalSnapshot, "transcript: user: lifecycle recovered");
		assertContains(report.finalSnapshot, "transcript: assistant: session fresh");
		assertContains(report.finalSnapshot, "transcript: plan: session lifecycle preserved");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"session\"");
		assertContains(report.summary(), "jsonMethod=thread/read;jsonParams=");
		assertContains(report.summary(), "\"threadId\":\"thread-session-a\"");
		assertContains(report.summary(), "\"includeTurns\":true");
		assertNotContains(report.summary(), "\"previewOnly\"");
		assertContains(report.summary(), "session-cancel:ok=true;code=cancelled;request=session-preview-pending;method=thread/read;pending=1");
		assertContains(report.summary(), "fanout-complete:ok=false;code=unknown_request_id;request=session-preview-pending;method=thread/read;pending=1");
		assertContains(report.summary(), "session-cancel:ok=true;code=cancelled;request=session-page-pending;method=thread/list;pending=0");
		assertContains(report.summary(), "session-disconnect:ok=true;code=disconnected;request=;method=;pending=0");
		assertContains(report.summary(), "after-disconnect-refusal:pending=0:ok=false;code=transport_closed");
		assertContains(report.summary(), "first:1:clientError:control:thread/read:session-preview-pending");
		assertContains(report.summary(), "first:2:clientError:control:thread/list:session-page-pending");
		assertContains(report.summary(), "first:3:disconnected:control");
		assertContains(report.summary(), "recovery:1:clientResponse:control:thread/list:session-recovery-page");
		assertContains(report.summary(), "recovery:2:clientResponse:control:thread/read:session-recovery-transcript");

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
