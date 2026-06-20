import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffKind;
import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderGate;

class ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderGate.run();

		assertEquals(Std.string(ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffKind.IdleListReady), Std.string(report.handoffKind), "handoff kind");
		assertTrue(report.idleListReady, "handoff should produce idle/list-ready state");
		assertEquals("thread-surface-a", report.recoveredThreadId, "recovered thread");
		assertTrue(report.keyboardInputReady, "keyboard input should be ready");
		assertTrue(report.listNavigationReady, "list navigation should be ready");
		assertTrue(report.promptActionCleared, "prompt action should be cleared");
		assertTrue(report.sideParentActionCleared, "side-parent action should be cleared");
		assertTrue(report.activeThreadActionCleared, "active-thread action should be cleared");
		assertTrue(report.restoredStatusAccepted, "restored status should be accepted");
		assertTrue(report.frameRequestAccepted, "frame request should be accepted");
		assertTrue(report.selectionAccepted, "selection should be accepted");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "handoff should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertContains(report.finalSnapshot, "resume-picker action=resume");
		assertContains(report.finalSnapshot, "rows loaded=2 filtered=2");
		assertContains(report.finalSnapshot, "footer typed surface recovered selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "handoffKind=idle_list_ready");
		assertContains(report.summary(), "reason=recovery_follow_up_handed_to_idle_list");
		assertContains(report.summary(), "kind=restored_list_status");
		assertContains(report.summary(), "kind=schedule_recovery_frame");
		assertContains(report.summary(), "kind=recovered_selection_ready");
		assertNotContains(report.summary(), "handoff_rejected");
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
