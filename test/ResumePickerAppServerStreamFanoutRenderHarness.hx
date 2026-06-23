import codexhx.runtime.tui.resume.live.AppServerStreamFanoutGate;

class StreamFanoutRenderHarness {
	static function main():Void {
		final report = AppServerStreamFanoutGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.requestShapePreserved, "app-server stream fanout should preserve JSON-RPC request shape");
		assertTrue(report.pendingOwnershipModeled, "fanout should hold and release typed pending requests deterministically");
		assertTrue(report.backpressureRouted, "lossless stream backpressure should route as a typed host failure");
		assertTrue(report.jsonRpcErrorMapped, "JSON-RPC read errors should route as typed picker host failures");
		assertTrue(report.pageDecoded, "thread/list fanout response should decode page rows");
		assertTrue(report.previewDecoded, "thread/read fanout response should decode preview lines");
		assertTrue(report.transcriptDecoded, "thread/read fanout response should decode transcript cells");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("4", Std.string(report.readRequests), "read requests");
		assertEquals("6", Std.string(report.frameRequests), "frame requests");
		assertEquals("6", Std.string(report.renderCount), "render count");
		assertEquals("6", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "> Fanout kernel row | thread-fanout-a | turns=2 | 2026-06-19T23:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[2], "preview: user: stream fanout");
		assertContains(snapshots[2], "preview: assistant: preview decoded");
		assertNotContains(snapshots[2], "hidden by cap");
		assertContains(snapshots[3], "error code=json_rpc_response_rejected message=failed:lossless event requires consumer capacity");
		assertContains(snapshots[4], "error code=json_rpc_thread_read_error message=-32602:thread not loaded");
		assertContains(report.finalSnapshot, "overlay transcript thread=thread-fanout-a cells=3");
		assertContains(report.finalSnapshot, "transcript: user: stream fanout");
		assertContains(report.finalSnapshot, "transcript: assistant: transcript decoded");
		assertContains(report.finalSnapshot, "transcript: plan: stream fanout preserved");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"fanout\"");
		assertContains(report.summary(), "jsonMethod=thread/read;jsonParams=");
		assertContains(report.summary(), "\"threadId\":\"thread-fanout-a\"");
		assertContains(report.summary(), "\"includeTurns\":true");
		assertNotContains(report.summary(), "\"previewOnly\"");
		assertContains(report.summary(), "fanout-send:ok=true;code=accepted;request=fanout-blocked-transcript;method=thread/read;pending=3");
		assertContains(report.summary(),
			"fanout-error:ok=false;code=failed;request=fanout-blocked-transcript;method=thread/read;pending=0;message=lossless event requires consumer capacity");
		assertContains(report.summary(), "after-page=1");
		assertContains(report.summary(), "after-preview=2");
		assertContains(report.summary(), "after-transcript=3");
		assertContains(report.summary(), "clientResponse:control:thread/list:fanout-page-1");
		assertContains(report.summary(), "clientResponse:control:thread/read:fanout-preview-read");
		assertContains(report.summary(), "clientError:control:thread/read:fanout-read-error");
		assertContains(report.summary(), "clientResponse:control:thread/read:fanout-transcript-read");
		assertContains(report.summary(), "transcript:thread=thread-fanout-a;previewState=loaded;previewLines=2;overlay=true;cells=3;errorShown=false");

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
