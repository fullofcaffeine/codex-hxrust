import codexhx.validation.tui.resume.live.ReplayAwareKeyboardStateGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardRenderStateRenderHarness {
	static function main():Void {
		final report = ReplayAwareKeyboardStateGate.run();

		assertEquals("2", Std.string(report.readinessDecisionCount), "readiness decisions");
		assertEquals("2", Std.string(report.renderStateCount), "render states");
		assertEquals("2", Std.string(report.frameRequests), "frame requests");
		assertEquals("2", Std.string(report.renderCount), "render count");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.sourceRenderCount), "source render count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertEquals("footer keyboard move_up selected=0 selectedThread=thread-surface-a", report.finalFooter, "final footer");
		assertTrue(report.selectedMarkerMoved, "selected marker should move to navigation target");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should be restored");
		assertTrue(report.noLeftoverScheduledRenderRequest, "scheduled render request should remain consumed");
		assertTrue(report.renderedSnapshotPreserved, "source rendered snapshot should be preserved");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertTrue(report.localOnlyRenderIntent, "render intent should stay local-only");
		assertEquals("2", Std.string(report.replayCount), "replay count");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.sourceSelectedMarkerMoved, "source selected marker movement should carry forward");
		assertTrue(report.sourceRecoveredSelectionRestored, "source recovered selection should carry forward");
		assertEquals("1", Std.string(report.sourcePreExecutionSchedulerRequestCount), "source pre-execution scheduler request count");
		assertEquals("1", Std.string(report.sourcePreExecutionConsumedRequestCount), "source pre-execution consumed request count");
		assertEquals("1", Std.string(report.sourcePreExecutionRenderCount), "source pre-execution render count");
		assertTrue(report.sourceRenderedSnapshotPreserved, "source rendered snapshot should be preserved");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "render state should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.renderSnapshots[0], "> Recovered navigation target | thread-surface-b");
		assertContains(report.renderSnapshots[1], "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "readinessDecisionCount=2;renderStateCount=2;frameRequests=2;renderCount=2");
		assertContains(report.summary(), "selectedMarkerMoved=true;recoveredSelectionRestored=true;noLeftoverScheduledRenderRequest=true");
		assertContains(report.summary(), "sourceSchedulerRequestCount=1;consumedScheduledRequestCount=1;sourceRenderCount=1");
		assertContains(report.summary(), "inputAdmitted=true;localOnlyRenderIntent=true;replayCount=2;snapshotOrderPreserved=true");
		assertContains(report.summary(), "selectedMarkersPreserved=true;footerSummariesPreserved=true;sourceSelectedMarkerMoved=true");
		assertContains(report.summary(), "sourceRecoveredSelectionRestored=true;sourcePreExecutionSchedulerRequestCount=1");
		assertContains(report.summary(), "kind=navigation_render_state;intent=move_down;sequence=1;selectedIndex=1;selectedThread=thread-surface-b");
		assertContains(report.summary(), "kind=navigation_render_state;intent=move_up;sequence=2;selectedIndex=0;selectedThread=thread-surface-a");
		assertContains(report.summary(), "selectedMarker=> Recovered navigation target | thread-surface-b");
		assertContains(report.summary(), "selectedMarker=> Recovered surface thread | thread-surface-a");
		assertContains(report.summary(), "reason=recovery_keyboard_render_state_projected");
		assertContains(report.summary(), "readinessKind=post_render_keyboard_ready");
		assertContains(report.summary(), "reason=post_completion_post_render_replay_aware_keyboard_ready");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true");
		assertNotContains(report.summary(), "post_completion_post_render_replay_aware_keyboard_render_state_decision_rejected");
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
