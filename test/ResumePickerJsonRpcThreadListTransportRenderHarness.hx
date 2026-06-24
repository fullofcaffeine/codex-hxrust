import codexhx.validation.tui.resume.live.JsonRpcThreadListTransportGate;

class ResumePickerJsonRpcThreadListTransportRenderHarness {
	static function main():Void {
		final report = JsonRpcThreadListTransportGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.requestShapePreserved, "JSON-RPC method/params/request-id shape should be preserved");
		assertTrue(report.responseDecoded, "thread/list response should decode into picker rows");
		assertTrue(report.errorMapped, "JSON-RPC error should map to typed host failure and visible picker state");
		assertTrue(report.recoveryDecoded, "later JSON-RPC response should recover visible rows");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("3", Std.string(report.pageRequests), "page requests");
		assertEquals("3", Std.string(report.frameRequests), "frame requests");
		assertEquals("3", Std.string(report.renderCount), "render count");
		assertEquals("3", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "> JSON-RPC kernel row | thread-jsonrpc-a | turns=2 | 2026-06-19T22:00:00Z | cwd=/workspace/codex-hxrust");
		assertContains(snapshots[0], "page next=cursor-jsonrpc-2 moreBelow=true loadingOlder=false scanCap=false nextPresent=true");
		assertContains(snapshots[1], "error code=json_rpc_thread_list_error message=-32042:fixture thread/list transport failed");
		assertContains(snapshots[1],
			"loader status=json_rpc_thread_list_error_mapped detail=request=jsonrpc-error-page;sourceCode=json_rpc_thread_list_error;preservedThread=thread-jsonrpc-a;rows=2");
		assertContains(report.finalSnapshot,
			"> JSON-RPC recovered row | thread-jsonrpc-recovered | turns=3 | 2026-06-19T22:10:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "jsonMethod=thread/list;jsonParams=");
		assertContains(report.summary(), "\"searchTerm\":\"kernel\"");
		assertContains(report.summary(), "\"sourceKinds\":[\"cli\",\"appServer\",\"subAgent\"]");
		assertContains(report.summary(), "send:ok=true;code=accepted;request=jsonrpc-page-1;method=thread/list");
		assertContains(report.summary(), "complete:ok=true;code=completed;request=jsonrpc-page-1;method=thread/list");
		assertContains(report.summary(), "error:ok=true;code=failed;request=jsonrpc-error-page;method=thread/list");
		assertContains(report.summary(), "clientResponse:control:thread/list:jsonrpc-page-1");
		assertContains(report.summary(), "clientError:control:thread/list:jsonrpc-error-page");
		assertContains(report.summary(), "recovery:query=kernel;sort=updated_at;filter=all;rows=1;selected=0;thread=thread-jsonrpc-recovered;errorShown=false");

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
