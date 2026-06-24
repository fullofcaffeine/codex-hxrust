import codexhx.validation.tui.resume.live.JsonRpcThreadReadTransportGate;

class ResumePickerJsonRpcThreadReadTransportRenderHarness {
	static function main():Void {
		final report = JsonRpcThreadReadTransportGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.requestShapePreserved, "JSON-RPC thread/read method/params/request-id shape should be preserved");
		assertTrue(report.previewDecoded, "thread/read preview response should decode and cap preview lines");
		assertTrue(report.transcriptDecoded, "thread/read transcript response should decode transcript cells");
		assertTrue(report.errorMapped, "JSON-RPC thread/read error should map to typed host failure and visible picker state");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("3", Std.string(report.readRequests), "read requests");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "preview: user: continue raw codex");
		assertContains(snapshots[1], "preview: assistant: preview ready");
		assertNotContains(snapshots[1], "hidden by preview cap");
		assertContains(snapshots[2], "error code=json_rpc_thread_read_error message=-32602:thread not loaded");
		assertContains(snapshots[2],
			"loader status=json_rpc_thread_read_error_mapped detail=request=jsonrpc-read-error;thread=thread-jsonrpc-missing;sourceCode=json_rpc_thread_read_error;previewThread=thread-jsonrpc-a");
		assertContains(report.finalSnapshot, "overlay transcript thread=thread-jsonrpc-a cells=3");
		assertContains(report.finalSnapshot, "transcript: user: continue raw codex");
		assertContains(report.finalSnapshot, "transcript: assistant: transcript ready");
		assertContains(report.finalSnapshot, "transcript: plan: keep upstream read shape");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "jsonMethod=thread/read;jsonParams=");
		assertContains(report.summary(), "\"threadId\":\"thread-jsonrpc-a\"");
		assertContains(report.summary(), "\"includeTurns\":true");
		assertNotContains(report.summary(), "\"previewOnly\"");
		assertNotContains(report.summary(), "\"maxPreviewLines\"");
		assertContains(report.summary(), "send:ok=true;code=accepted;request=jsonrpc-preview-read;method=thread/read");
		assertContains(report.summary(), "complete:ok=true;code=completed;request=jsonrpc-preview-read;method=thread/read");
		assertContains(report.summary(), "error:ok=true;code=failed;request=jsonrpc-read-error;method=thread/read");
		assertContains(report.summary(), "clientResponse:control:thread/read:jsonrpc-preview-read");
		assertContains(report.summary(), "clientError:control:thread/read:jsonrpc-read-error");
		assertContains(report.summary(), "transcript:thread=thread-jsonrpc-a;previewState=loaded;previewLines=2;overlay=true;cells=3;errorShown=false");

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
