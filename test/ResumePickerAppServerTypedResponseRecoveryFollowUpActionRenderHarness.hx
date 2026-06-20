import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGate;

class ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGate.run();

		assertEquals("3", Std.string(report.actionCount), "follow-up actions");
		assertEquals("1", Std.string(report.restoredStatusActionCount), "restored status action");
		assertEquals("1", Std.string(report.frameActionCount), "frame action");
		assertEquals("1", Std.string(report.selectionActionCount), "selection action");
		assertEquals("1", Std.string(report.followUpFrameRequests), "follow-up frame requests");
		assertTrue(report.stalePromptActionAbsent, "stale prompt actions should be absent");
		assertTrue(report.staleSideParentActionAbsent, "stale side-parent actions should be absent");
		assertTrue(report.staleActiveThreadActionAbsent, "stale active-thread actions should be absent");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.recoveryConfirmed, "recovery should be confirmed");
		assertTrue(report.noPressureDropRejection, "follow-up action gate should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertEquals("thread-surface-a", report.recoveredThreadId, "recovered thread");
		assertContains(report.finalSnapshot, "footer typed surface recovered selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "kind=restored_list_status;sequence=1");
		assertContains(report.summary(), "kind=schedule_recovery_frame;sequence=2");
		assertContains(report.summary(), "kind=recovered_selection_ready;sequence=3");
		assertContains(report.summary(), "reason=recovered_list_status_restored");
		assertContains(report.summary(), "reason=recovery_frame_requested");
		assertContains(report.summary(), "reason=recovered_selection_ready");
		assertContains(report.summary(), "reason=recovery_page_replaced_transient_response_surfaces");
		assertNotContains(report.summary(), "stalePromptAction=true");
		assertNotContains(report.summary(), "staleSideParentAction=true");
		assertNotContains(report.summary(), "staleActiveThreadAction=true");
		assertNotContains(report.summary(), "liveTransport=true");
		assertNotContains(report.summary(), "server-request-rejected");
		assertNotContains(report.summary(), "consumer_queue_full");

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
