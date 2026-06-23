import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind;
import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleReplayCompletionHandoffRenderGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleReplayCompletionHandoffRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleReplayCompletionHandoffRenderGate.run();
		final summary = report.summary();

		assertKindEquals(ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind.CompletedRecoveredSelection, report.handoffKind, "handoff kind");
		assertTrue(report.completionReady, "completion should be ready");
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
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffReplayCount), "second-cycle source handoff replay count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffReadinessDecisionCount), "second-cycle handoff readiness decision count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffRenderStateCount), "second-cycle handoff render state count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffFrameRequests), "second-cycle handoff frame requests");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffKeyboardRenderCount), "second-cycle handoff keyboard render count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffReplayCount), "third-cycle source handoff replay count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffReadinessDecisionCount), "third-cycle handoff readiness decision count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffRenderStateCount), "third-cycle handoff render state count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffFrameRequests), "third-cycle handoff frame requests");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffKeyboardRenderCount), "third-cycle handoff keyboard render count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertEquals("footer keyboard move_up selected=0 selectedThread=thread-surface-a", report.finalFooter, "final footer");
		assertTrue(report.finalFooterStable, "final footer should be stable");
		assertTrue(report.finalSelectionRestored, "final selection should be restored");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.selectedMarkerMoved, "selected marker movement should carry forward");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should stay restored");
		assertTrue(report.noLeftoverScheduledRenderRequest, "scheduled render request should remain consumed");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.sourcePostRenderRenderCount), "source post-render render count");
		assertTrue(report.renderedSnapshotPreserved, "source rendered snapshot should be preserved");
		assertTrue(report.sourceRenderedSnapshotPreserved, "source pre-execution rendered snapshot should be preserved");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should stay admitted");
		assertTrue(report.localOnlyRenderIntent, "source render intent should stay local-only");
		assertTrue(report.sourceInputAdmitted, "source input evidence should carry forward");
		assertTrue(report.sourceLocalOnlyRenderIntent, "source render-intent evidence should carry forward");
		assertTrue(report.sourceHandoffInputAdmitted, "source handoff input evidence should carry forward");
		assertTrue(report.sourceHandoffLocalOnlyRenderIntent, "source handoff render-intent evidence should carry forward");
		assertTrue(report.sourceSecondCycleHandoffInputAdmitted, "second-cycle handoff input evidence should carry forward");
		assertTrue(report.sourceSecondCycleHandoffLocalOnlyRenderIntent, "second-cycle handoff render-intent evidence should carry forward");
		assertTrue(report.sourceThirdCycleHandoffInputAdmitted, "third-cycle handoff input evidence should carry forward");
		assertTrue(report.sourceThirdCycleHandoffLocalOnlyRenderIntent, "third-cycle handoff render-intent evidence should carry forward");
		assertTrue(report.sourceFourthCycleHandoffInputAdmitted, "fourth-cycle handoff input evidence should carry forward");
		assertTrue(report.sourceFourthCycleHandoffLocalOnlyRenderIntent, "fourth-cycle handoff render-intent evidence should carry forward");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "completion handoff should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertTrue(report.nextSliceReady, "next slice should be ready");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertUnder(11000, summary.length, "summary length");
		assertContains(summary, "handoffKind=completed_recovered_selection;completionReady=true");
		assertContains(summary, "sourceReadinessDecisionCount=2;sourceRenderStateCount=2;sourceFrameRequests=2;sourceKeyboardRenderCount=2");
		assertContains(summary, "replayCount=2;sourceReplayCount=2;sourceHandoffReplayCount=2");
		assertContains(summary,
			"sourceHandoffReadinessDecisionCount=2;sourceHandoffRenderStateCount=2;sourceHandoffFrameRequests=2;sourceHandoffKeyboardRenderCount=2");
		assertContains(summary, "sourceSecondCycleHandoffReplayCount=2;sourceSecondCycleHandoffReadinessDecisionCount=2");
		assertContains(summary, "sourceSecondCycleHandoffRenderStateCount=2;sourceSecondCycleHandoffFrameRequests=2");
		assertContains(summary, "sourceSecondCycleHandoffKeyboardRenderCount=2;sourceThirdCycleHandoffReplayCount=2");
		assertContains(summary, "sourceThirdCycleHandoffReadinessDecisionCount=2;sourceThirdCycleHandoffRenderStateCount=2");
		assertContains(summary, "sourceThirdCycleHandoffFrameRequests=2;sourceThirdCycleHandoffKeyboardRenderCount=2");
		assertContains(summary, "finalFooterStable=true;finalSelectionRestored=true;snapshotOrderPreserved=true");
		assertContains(summary, "selectedMarkersPreserved=true;footerSummariesPreserved=true;selectedMarkerMoved=true");
		assertContains(summary, "sourceSchedulerRequestCount=1;consumedScheduledRequestCount=1;sourcePostRenderRenderCount=1");
		assertContains(summary, "inputAdmitted=true;localOnlyRenderIntent=true;sourceInputAdmitted=true;sourceLocalOnlyRenderIntent=true");
		assertContains(summary, "sourceHandoffInputAdmitted=true;sourceHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "sourceSecondCycleHandoffInputAdmitted=true;sourceSecondCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "sourceThirdCycleHandoffInputAdmitted=true;sourceThirdCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "sourceFourthCycleHandoffInputAdmitted=true;sourceFourthCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "reason=post_completion_post_render_replay_aware_rendered_state_seventh_cycle_replay_completed_for_next_slice");
		assertContains(summary, "reason=post_completion_post_render_replay_aware_rendered_state_seventh_cycle_keyboard_snapshot_replayed");
		assertContains(summary, "noModelCall=true;noFilesystemMutation=true;nextSliceReady=true");
		assertNotContains(summary, "post_completion_post_render_replay_aware_rendered_state_seventh_cycle_replay_completion_rejected");
		assertNotContains(summary, "post_completion_post_render_replay_aware_rendered_state_seventh_cycle_keyboard_render_state_decision_rejected");
		assertNotContains(summary, "post_render_keyboard_readiness_rejected");
		assertNotContains(summary, "navigation_rejected");
		assertNotContains(summary, "stalePromptAction=true");
		assertNotContains(summary, "staleSideParentAction=true");
		assertNotContains(summary, "staleActiveThreadAction=true");
		assertNotContains(summary, "liveTransport=true");
		assertNotContains(summary, "liveTerminal=true");
		assertNotContains(summary, "server-request-rejected");
		assertNotContains(summary, "consumer_queue_full");

		Sys.println(summary);
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertNotContains(value:String, needle:String):Void {
		if (value.indexOf(needle) >= 0)
			throw "did not expect `" + needle + "` in `" + value + "`";
	}

	static function assertKindEquals(expected:ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind,
			actual:ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}

	static function assertUnder(maxExclusive:Int, actual:Int, label:String):Void {
		if (actual >= maxExclusive)
			throw label + " expected under " + maxExclusive + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
