import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderGate;

class ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderGate.run();

		assertEquals("2", Std.string(report.decisionCount), "keyboard decisions");
		assertEquals("2", Std.string(report.admittedCount), "admitted decisions");
		assertTrue(report.recoveredSelectionStableUntilNavigation, "recovered selection should be stable before navigation");
		assertTrue(report.navigationApplied, "down/up navigation should be applied");
		assertTrue(report.returnedToRecoveredSelection, "up navigation should return to recovered selection");
		assertTrue(report.keyboardInputReady, "keyboard input should be ready");
		assertTrue(report.listNavigationReady, "list navigation should be ready");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "keyboard readiness should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertContains(report.summary(), "intent=move_down;sequence=1;selectedBefore=0;selectedAfter=1");
		assertContains(report.summary(), "intent=move_up;sequence=2;selectedBefore=1;selectedAfter=0");
		assertContains(report.summary(), "threadBefore=thread-surface-a;threadAfter=thread-surface-b");
		assertContains(report.summary(), "threadBefore=thread-surface-b;threadAfter=thread-surface-a");
		assertContains(report.summary(), "reason=recovery_keyboard_navigation_ready");
		assertContains(report.summary(), "reason=recovery_follow_up_handed_to_idle_list");
		assertNotContains(report.summary(), "navigation_rejected");
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
