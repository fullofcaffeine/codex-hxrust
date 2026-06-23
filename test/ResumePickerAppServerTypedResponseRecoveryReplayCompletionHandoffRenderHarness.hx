import codexhx.runtime.tui.resume.live.RecoveryCompletionHandoffGate;

class RecoveryReplayCompletionHandoffRenderHarness {
	static function main():Void {
		final report = RecoveryCompletionHandoffGate.run();

		assertEquals("completed_recovered_selection", Std.string(report.handoffKind), "handoff kind");
		assertEquals("2", Std.string(report.replayCount), "replay count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertTrue(report.completionReady, "completion should be ready");
		assertTrue(report.finalFooterStable, "final footer should be stable");
		assertTrue(report.finalSelectionRestored, "final selection should be restored");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "handoff should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.nextSliceReady, "next slice should be ready");
		assertContains(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "handoffKind=completed_recovered_selection;completionReady=true;replayCount=2;finalThread=thread-surface-a");
		assertContains(report.summary(), "finalFooterStable=true;finalSelectionRestored=true");
		assertContains(report.summary(), "finalFooter=footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "nextSliceReady=true;reason=recovery_replay_completed_for_next_slice");
		assertContains(report.summary(), "sourceRenderStateCount=2;replayCount=2;snapshotOrderPreserved=true");
		assertNotContains(report.summary(), "completion_rejected");
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
