import codexhx.runtime.tui.resume.live.ReplayStateSnapshotReplayGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateKeyboardRenderSnapshotReplayRenderHarness {
	static function main():Void {
		final report = ReplayStateSnapshotReplayGate.run();

		assertEquals("2", Std.string(report.sourceReadinessDecisionCount), "source readiness decisions");
		assertEquals("2", Std.string(report.sourceRenderStateCount), "source render states");
		assertEquals("2", Std.string(report.sourceFrameRequests), "source frame requests");
		assertEquals("2", Std.string(report.sourceKeyboardRenderCount), "source keyboard render count");
		assertEquals("2", Std.string(report.replayCount), "replay count");
		assertEquals("2", Std.string(report.sourceReplayCount), "source replay count");
		assertEquals("2", Std.string(report.sourceHandoffReplayCount), "source handoff replay count");
		assertEquals("2", Std.string(report.sourceHandoffReadinessDecisionCount), "source handoff readiness decision count");
		assertEquals("2", Std.string(report.sourceHandoffRenderStateCount), "source handoff render state count");
		assertEquals("2", Std.string(report.sourceHandoffFrameRequests), "source handoff frame requests");
		assertEquals("2", Std.string(report.sourceHandoffKeyboardRenderCount), "source handoff keyboard render count");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.sourcePostRenderRenderCount), "source post-render render count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertEquals("footer keyboard move_up selected=0 selectedThread=thread-surface-a", report.finalFooter, "final footer");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.selectedMarkerMoved, "selected marker movement should carry forward");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should stay restored");
		assertTrue(report.noLeftoverScheduledRenderRequest, "scheduled render request should remain consumed");
		assertTrue(report.renderedSnapshotPreserved, "source rendered snapshot should be preserved");
		assertTrue(report.sourceRenderedSnapshotPreserved, "source pre-execution rendered snapshot should be preserved");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should stay admitted");
		assertTrue(report.localOnlyRenderIntent, "source render intent should stay local-only");
		assertTrue(report.sourceInputAdmitted, "source input evidence should carry forward");
		assertTrue(report.sourceLocalOnlyRenderIntent, "source render-intent evidence should carry forward");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "snapshot replay should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.replayedSnapshots[0], "> Recovered navigation target | thread-surface-b");
		assertContains(report.replayedSnapshots[0], "footer keyboard move_down selected=1 selectedThread=thread-surface-b");
		assertContains(report.replayedSnapshots[1], "> Recovered surface thread | thread-surface-a");
		assertContains(report.replayedSnapshots[1], "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "sourceReadinessDecisionCount=2;sourceRenderStateCount=2;sourceFrameRequests=2;sourceKeyboardRenderCount=2");
		assertContains(report.summary(), "replayCount=2;sourceReplayCount=2;sourceHandoffReplayCount=2");
		assertContains(report.summary(),
			"sourceHandoffReadinessDecisionCount=2;sourceHandoffRenderStateCount=2;sourceHandoffFrameRequests=2;sourceHandoffKeyboardRenderCount=2");
		assertContains(report.summary(), "snapshotOrderPreserved=true;selectedMarkersPreserved=true;footerSummariesPreserved=true");
		assertContains(report.summary(), "selectedMarkerMoved=true;recoveredSelectionRestored=true;noLeftoverScheduledRenderRequest=true");
		assertContains(report.summary(), "sourceSchedulerRequestCount=1;consumedScheduledRequestCount=1;sourcePostRenderRenderCount=1");
		assertContains(report.summary(), "inputAdmitted=true;localOnlyRenderIntent=true;sourceInputAdmitted=true;sourceLocalOnlyRenderIntent=true");
		assertContains(report.summary(), "kind=keyboard_navigation_snapshot;intent=move_down;replayIndex=0;sourceSequence=1;selectedThread=thread-surface-b");
		assertContains(report.summary(), "kind=keyboard_navigation_snapshot;intent=move_up;replayIndex=1;sourceSequence=2;selectedThread=thread-surface-a");
		assertContains(report.summary(), "expectedMarker=> Recovered navigation target | thread-surface-b");
		assertContains(report.summary(), "expectedMarker=> Recovered surface thread | thread-surface-a");
		assertContains(report.summary(), "expectedFooter=footer keyboard move_down selected=1 selectedThread=thread-surface-b");
		assertContains(report.summary(), "expectedFooter=footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "markerMatched=true;footerMatched=true;orderPreserved=true");
		assertContains(report.summary(), "reason=post_completion_post_render_replay_aware_rendered_state_keyboard_snapshot_replayed");
		assertContains(report.summary(), "reason=post_completion_post_render_replay_aware_rendered_state_keyboard_render_state_decision_ready");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true");
		assertNotContains(report.summary(), "post_completion_post_render_replay_aware_rendered_state_keyboard_render_state_decision_rejected");
		assertNotContains(report.summary(), "post_render_keyboard_readiness_rejected");
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
