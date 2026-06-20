import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponsePayloadEnvelopeRenderGate;

class ResumePickerAppServerTypedResponsePayloadEnvelopeRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponsePayloadEnvelopeRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertTrue(report.execPayloadRecorded, "exec approval response payload should be recorded");
		assertTrue(report.filePayloadRecorded, "file-change approval response payload should be recorded");
		assertTrue(report.permissionsPayloadRecorded, "permissions response payload should be recorded");
		assertTrue(report.userInputPayloadRecorded, "tool request-user-input response payload should be recorded");
		assertTrue(report.mcpPayloadRecorded, "MCP elicitation response payload should be recorded");
		assertTrue(report.unsupportedErrorRecorded, "unsupported request should produce JSON-RPC error envelope");
		assertTrue(report.missingPendingNoopRecorded, "missing pending response should be local no-op");
		assertTrue(report.requestIdsCorrelated, "typed response envelopes should preserve request correlations");
		assertTrue(report.noPressureDropRejection, "typed response payload gate should not look like stream pressure rejection");
		assertTrue(report.liveTransportSuppressed, "gate must suppress live transport");
		assertTrue(report.recoveryDecoded, "page recovery should decode after typed response payload envelopes");
		assertTrue(report.noCredentialOrModelTraffic, "gate must remain credential-free and model-free");
		assertTrue(report.stateDbUntouched, "gate must not mutate state DB");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("9", Std.string(report.frameRequests), "frame requests");
		assertEquals("9", Std.string(report.renderCount), "render count");
		assertEquals("9", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[1], "loader status=typed_response_exec_payload");
		assertContains(snapshots[1], "payloadKind=command_execution_approval_response;request=typed-response-exec-1");
		assertContains(snapshots[2], "loader status=typed_response_file_payload");
		assertContains(snapshots[2], "payloadKind=file_change_approval_response;request=typed-response-file-2");
		assertContains(snapshots[3], "loader status=typed_response_permissions_payload");
		assertContains(snapshots[3], "payloadKind=permissions_approval_response;request=typed-response-permissions-3");
		assertContains(snapshots[4], "loader status=typed_response_user_input_payload");
		assertContains(snapshots[4], "payloadKind=tool_request_user_input_response;request=typed-response-user-input-4");
		assertContains(snapshots[5], "loader status=typed_response_mcp_payload");
		assertContains(snapshots[5], "payloadKind=mcp_elicitation_response;request=typed-response-mcp-5");
		assertContains(snapshots[6], "loader status=typed_response_unsupported_error");
		assertContains(snapshots[6], "kind=reject_error;class=dynamic_tool_call;payloadKind=json_rpc_error");
		assertContains(snapshots[7], "loader status=typed_response_missing_pending_noop");
		assertContains(snapshots[7], "kind=missing_pending_noop;class=exec_approval;payloadKind=missing_pending_noop");
		assertContains(snapshots[8], "loader status=typed_response_recovery_page_decoded");
		assertContains(report.finalSnapshot,
			"> Typed response response row A | thread-response-a | turns=2 | 2026-06-20T05:45:00Z | cwd=/workspace/codex-hxrust");
		assertNotContains(report.finalSnapshot, "error code=");
		assertContains(report.summary(), "\"decision\":\"accept\"");
		assertContains(report.summary(), "\"decision\":\"apply\"");
		assertContains(report.summary(), "\"scope\":\"session\"");
		assertContains(report.summary(), "\"answers\"");
		assertContains(report.summary(), "\"action\":\"accept\"");
		assertContains(report.summary(), "\"error\":{\"code\":\"unsupported_request_class\"");
		assertContains(report.summary(), "kind=missing_pending_noop;class=exec_approval");
		assertContains(report.summary(), "correlation=server:typed-response-exec-1");
		assertContains(report.summary(), "correlation=server:typed-response-mcp-5");
		assertContains(report.summary(), "rejectedRequests=[]");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");
		assertContains(report.summary(), "\"searchTerm\":\"typed response\"");

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
