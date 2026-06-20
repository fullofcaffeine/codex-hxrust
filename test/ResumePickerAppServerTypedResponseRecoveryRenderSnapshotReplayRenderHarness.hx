import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderGate;

class ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderGate.run();

		assertEquals("2", Std.string(report.sourceRenderStateCount), "source render states");
		assertEquals("2", Std.string(report.replayCount), "replay count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "snapshot replay should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertContains(report.replayedSnapshots[0], "> Recovered navigation target | thread-surface-b");
		assertContains(report.replayedSnapshots[0], "footer keyboard move_down selected=1 selectedThread=thread-surface-b");
		assertContains(report.replayedSnapshots[1], "> Recovered surface thread | thread-surface-a");
		assertContains(report.replayedSnapshots[1], "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "kind=keyboard_navigation_snapshot;intent=move_down;replayIndex=0;sourceSequence=1;selectedThread=thread-surface-b");
		assertContains(report.summary(), "kind=keyboard_navigation_snapshot;intent=move_up;replayIndex=1;sourceSequence=2;selectedThread=thread-surface-a");
		assertContains(report.summary(), "expectedMarker=> Recovered navigation target | thread-surface-b");
		assertContains(report.summary(), "expectedMarker=> Recovered surface thread | thread-surface-a");
		assertContains(report.summary(), "markerMatched=true;footerMatched=true;orderPreserved=true");
		assertContains(report.summary(), "reason=recovery_keyboard_render_snapshot_replayed");
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
