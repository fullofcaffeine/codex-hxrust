import codexhx.runtime.tui.resume.live.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleKeyboardReadinessRenderGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleKeyboardReadinessRenderHarness {
	static function main():Void {
		final report = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleKeyboardReadinessRenderGate.run();

		assertEquals("post_render_keyboard_ready", Std.string(report.readinessKind), "readiness kind");
		assertEquals("2", Std.string(report.decisionCount), "decision count");
		assertEquals("2", Std.string(report.admittedCount), "admitted count");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertEquals("footer keyboard move_up selected=0 selectedThread=thread-surface-a", report.finalFooter, "final footer");
		assertTrue(report.postRenderIdleListReady, "post-render idle/list state should be ready");
		assertTrue(report.keyboardInputReady, "keyboard input should be ready");
		assertTrue(report.listNavigationReady, "list navigation should be ready");
		assertTrue(report.recoveredSelectionStableUntilNavigation, "recovered selection should be stable until navigation");
		assertTrue(report.navigationApplied, "navigation should be applied");
		assertTrue(report.returnedToRecoveredSelection, "navigation should return to recovered selection");
		assertTrue(report.noLeftoverScheduledRenderRequest, "scheduled render request should be consumed");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.renderCount), "render count");
		assertTrue(report.renderedSnapshotPreserved, "rendered snapshot should be preserved");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertTrue(report.localOnlyRenderIntent, "render intent should stay local-only");
		assertTrue(report.completionReady, "completion should be ready");
		assertTrue(report.nextSliceReady, "next slice should be ready");
		assertEquals("2", Std.string(report.replayCount), "replay count");
		assertEquals("2", Std.string(report.sourceReplayCount), "source replay count");
		assertEquals("2", Std.string(report.sourceHandoffReplayCount), "source handoff replay count");
		assertEquals("2", Std.string(report.sourceHandoffReadinessDecisionCount), "source handoff readiness decision count");
		assertEquals("2", Std.string(report.sourceHandoffRenderStateCount), "source handoff render-state count");
		assertEquals("2", Std.string(report.sourceHandoffFrameRequests), "source handoff frame requests");
		assertEquals("2", Std.string(report.sourceHandoffKeyboardRenderCount), "source handoff keyboard render count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffReplayCount), "second-cycle source handoff replay count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffReadinessDecisionCount), "second-cycle handoff readiness decision count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffRenderStateCount), "second-cycle handoff render-state count");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffFrameRequests), "second-cycle handoff frame requests");
		assertEquals("2", Std.string(report.sourceSecondCycleHandoffKeyboardRenderCount), "second-cycle handoff keyboard render count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffReplayCount), "third-cycle source handoff replay count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffReadinessDecisionCount), "third-cycle handoff readiness decision count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffRenderStateCount), "third-cycle handoff render-state count");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffFrameRequests), "third-cycle handoff frame requests");
		assertEquals("2", Std.string(report.sourceThirdCycleHandoffKeyboardRenderCount), "third-cycle handoff keyboard render count");
		assertEquals("2", Std.string(report.sourceReadinessDecisionCount), "source readiness decision count");
		assertEquals("2", Std.string(report.sourceRenderStateCount), "source render-state count");
		assertEquals("2", Std.string(report.sourceFrameRequests), "source frame requests");
		assertEquals("2", Std.string(report.sourceKeyboardRenderCount), "source keyboard render count");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.selectedMarkerMoved, "selected marker movement should carry forward");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should stay restored");
		assertEquals("1", Std.string(report.sourcePreExecutionSchedulerRequestCount), "source pre-execution scheduler request count");
		assertEquals("1", Std.string(report.sourcePreExecutionConsumedRequestCount), "source pre-execution consumed request count");
		assertEquals("1", Std.string(report.sourcePreExecutionRenderCount), "source pre-execution render count");
		assertTrue(report.sourceRenderedSnapshotPreserved, "source rendered snapshot should be preserved");
		assertTrue(report.sourceInputAdmitted, "source input should stay admitted");
		assertTrue(report.sourceLocalOnlyRenderIntent, "source render intent should stay local-only");
		assertTrue(report.sourceHandoffInputAdmitted, "source handoff input evidence should carry forward");
		assertTrue(report.sourceHandoffLocalOnlyRenderIntent, "source handoff render-intent evidence should carry forward");
		assertTrue(report.sourceSecondCycleHandoffInputAdmitted, "second-cycle handoff input evidence should carry forward");
		assertTrue(report.sourceSecondCycleHandoffLocalOnlyRenderIntent, "second-cycle handoff render-intent evidence should carry forward");
		assertTrue(report.sourceThirdCycleHandoffInputAdmitted, "third-cycle handoff input evidence should carry forward");
		assertTrue(report.sourceThirdCycleHandoffLocalOnlyRenderIntent, "third-cycle handoff render-intent evidence should carry forward");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "keyboard readiness should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "readinessKind=post_render_keyboard_ready;decisionCount=2;admittedCount=2");
		assertContains(report.summary(), "postRenderIdleListReady=true;keyboardInputReady=true;listNavigationReady=true");
		assertContains(report.summary(), "recoveredSelectionStableUntilNavigation=true;navigationApplied=true;returnedToRecoveredSelection=true");
		assertContains(report.summary(), "noLeftoverScheduledRenderRequest=true;sourceSchedulerRequestCount=1;consumedScheduledRequestCount=1");
		assertContains(report.summary(), "renderCount=1;renderedSnapshotPreserved=true;finalThread=thread-surface-a");
		assertContains(report.summary(), "inputAdmitted=true;localOnlyRenderIntent=true;completionReady=true;nextSliceReady=true");
		assertContains(report.summary(), "replayCount=2;sourceReplayCount=2;sourceHandoffReplayCount=2");
		assertContains(report.summary(), "sourceHandoffReadinessDecisionCount=2;sourceHandoffRenderStateCount=2");
		assertContains(report.summary(), "sourceHandoffFrameRequests=2;sourceHandoffKeyboardRenderCount=2");
		assertContains(report.summary(), "sourceSecondCycleHandoffReplayCount=2;sourceSecondCycleHandoffReadinessDecisionCount=2");
		assertContains(report.summary(), "sourceSecondCycleHandoffRenderStateCount=2;sourceSecondCycleHandoffFrameRequests=2");
		assertContains(report.summary(), "sourceSecondCycleHandoffKeyboardRenderCount=2;sourceThirdCycleHandoffReplayCount=2");
		assertContains(report.summary(), "sourceThirdCycleHandoffReadinessDecisionCount=2;sourceThirdCycleHandoffRenderStateCount=2");
		assertContains(report.summary(), "sourceThirdCycleHandoffFrameRequests=2;sourceThirdCycleHandoffKeyboardRenderCount=2");
		assertContains(report.summary(), "sourceReadinessDecisionCount=2;sourceRenderStateCount=2");
		assertContains(report.summary(), "sourceFrameRequests=2;sourceKeyboardRenderCount=2");
		assertContains(report.summary(), "selectedMarkersPreserved=true;footerSummariesPreserved=true;selectedMarkerMoved=true");
		assertContains(report.summary(), "recoveredSelectionRestored=true;sourcePreExecutionSchedulerRequestCount=1");
		assertContains(report.summary(), "sourceRenderedSnapshotPreserved=true;sourceInputAdmitted=true;sourceLocalOnlyRenderIntent=true");
		assertContains(report.summary(), "sourceHandoffInputAdmitted=true;sourceHandoffLocalOnlyRenderIntent=true");
		assertContains(report.summary(), "sourceSecondCycleHandoffInputAdmitted=true;sourceSecondCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(report.summary(), "sourceThirdCycleHandoffInputAdmitted=true;sourceThirdCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(report.summary(), "kind=post_render_keyboard_ready;sourceHandoffKind=rendered_idle_list_ready");
		assertContains(report.summary(), "kind=navigation_admitted;intent=move_down;sequence=1;selectedBefore=0;selectedAfter=1");
		assertContains(report.summary(), "kind=navigation_admitted;intent=move_up;sequence=2;selectedBefore=1;selectedAfter=0");
		assertContains(report.summary(), "reason=post_completion_post_render_replay_aware_rendered_state_fourth_cycle_keyboard_ready");
		assertContains(report.summary(), "reason=post_completion_post_render_replay_aware_rendered_state_fourth_cycle_keyboard_navigation_ready");
		assertContains(report.summary(), "reason=post_completion_post_render_replay_aware_rendered_state_third_cycle_scheduled_execution_handed_to_idle_list");
		assertContains(report.summary(), "handoffKind=rendered_idle_list_ready");
		assertContains(report.summary(), "liveTerminalSuppressed=true;stateDbUntouched=true;noModelCall=true;noFilesystemMutation=true");
		assertNotContains(report.summary(), "post_completion_post_render_replay_aware_rendered_state_fourth_cycle_keyboard_rejected");
		assertNotContains(report.summary(), "post_render_keyboard_readiness_rejected");
		assertNotContains(report.summary(), "rendered_state_handoff_rejected");
		assertNotContains(report.summary(), "render_execution_rejected");
		assertNotContains(report.summary(), "render_schedule_rejected");
		assertNotContains(report.summary(), "render_intent_rejected");
		assertNotContains(report.summary(), "input_rejected");
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
