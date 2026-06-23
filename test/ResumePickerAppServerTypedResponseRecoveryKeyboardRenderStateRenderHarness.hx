import codexhx.runtime.tui.resume.live.RecoveryKeyboardStateGate;

class RecoveryKeyboardRenderStateRenderHarness {
	static function main():Void {
		final report = RecoveryKeyboardStateGate.run();

		assertEquals("2", Std.string(report.readinessDecisionCount), "readiness decisions");
		assertEquals("2", Std.string(report.renderStateCount), "render states");
		assertEquals("2", Std.string(report.frameRequests), "frame requests");
		assertEquals("2", Std.string(report.renderCount), "render count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertTrue(report.selectedMarkerMoved, "selected marker should move to navigation target");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should be restored");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "render state should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertContains(report.renderSnapshots[0], "> Recovered navigation target | thread-surface-b");
		assertContains(report.renderSnapshots[1], "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "kind=navigation_render_state;intent=move_down;sequence=1;selectedIndex=1;selectedThread=thread-surface-b");
		assertContains(report.summary(), "kind=navigation_render_state;intent=move_up;sequence=2;selectedIndex=0;selectedThread=thread-surface-a");
		assertContains(report.summary(), "selectedMarker=> Recovered navigation target | thread-surface-b");
		assertContains(report.summary(), "selectedMarker=> Recovered surface thread | thread-surface-a");
		assertContains(report.summary(), "reason=recovery_keyboard_render_state_projected");
		assertContains(report.summary(), "readinessDecisionCount=2");
		assertNotContains(report.summary(), "navigation_rejected");
		assertNotContains(report.summary(), "stalePromptAction=true");
		assertNotContains(report.summary(), "staleSideParentAction=true");
		assertNotContains(report.summary(), "staleActiveThreadAction=true");
		assertNotContains(report.summary(), "liveTransport=true");
		assertNotContains(report.summary(), "liveTerminal=true");
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
