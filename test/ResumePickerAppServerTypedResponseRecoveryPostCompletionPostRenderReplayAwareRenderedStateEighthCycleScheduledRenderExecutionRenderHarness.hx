import codexhx.validation.tui.resume.live.EighthScheduledRenderGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleScheduledRenderExecutionRenderHarness {
	static function main():Void {
		final report = EighthScheduledRenderGate.run();
		final summary = report.summary();

		assertEquals("local_render_executed", Std.string(report.executionKind), "execution kind");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertEquals("footer keyboard move_up selected=0 selectedThread=thread-surface-a", report.finalFooter, "final footer");
		assertTrue(report.executionRequested, "execution should be requested");
		assertTrue(report.rendered, "scheduled render should execute");
		assertEquals("1", Std.string(report.executionSequence), "execution sequence");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.renderCount), "render count");
		assertEquals("rendered", Std.string(report.renderOutcomeKind), "render outcome kind");
		assertTrue(report.renderedSnapshotMatchesSchedule, "rendered snapshot should match scheduled snapshot");
		assertTrue(report.localOnlyRenderIntent, "render intent should stay local-only");
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
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertTrue(report.completionReady, "completion should be ready");
		assertTrue(report.nextSliceReady, "next slice should be ready");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.selectedMarkerMoved, "selected marker movement should carry forward");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should stay restored");
		assertTrue(report.noLeftoverScheduledRenderRequest, "source scheduled render request should remain consumed");
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
		assertTrue(report.sourceFourthCycleHandoffInputAdmitted, "fourth-cycle handoff input evidence should carry forward");
		assertTrue(report.sourceFourthCycleHandoffLocalOnlyRenderIntent, "fourth-cycle handoff render-intent evidence should carry forward");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "render execution should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.renderedSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.renderedSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertUnder(36000, summary.length, "summary length");
		assertContains(summary, "executionKind=local_render_executed;executionRequested=true;rendered=true;executionSequence=1;sourceSchedulerRequestCount=1");
		assertContains(summary, "consumedScheduledRequestCount=1;renderCount=1;renderOutcomeKind=rendered");
		assertContains(summary, "sourceSecondCycleHandoffReplayCount=2;sourceSecondCycleHandoffReadinessDecisionCount=2");
		assertContains(summary, "sourceSecondCycleHandoffRenderStateCount=2;sourceSecondCycleHandoffFrameRequests=2");
		assertContains(summary, "sourceSecondCycleHandoffKeyboardRenderCount=2;sourceThirdCycleHandoffReplayCount=2");
		assertContains(summary, "sourceThirdCycleHandoffReadinessDecisionCount=2;sourceThirdCycleHandoffRenderStateCount=2");
		assertContains(summary, "sourceThirdCycleHandoffFrameRequests=2;sourceThirdCycleHandoffKeyboardRenderCount=2");
		assertContains(summary, "sourceSecondCycleHandoffInputAdmitted=true;sourceSecondCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "sourceThirdCycleHandoffInputAdmitted=true;sourceThirdCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "sourceFourthCycleHandoffInputAdmitted=true;sourceFourthCycleHandoffLocalOnlyRenderIntent=true");
		assertContains(summary, "kind=local_render_executed;sourceScheduleKind=local_render_scheduled");
		assertContains(summary, "reason=post_completion_post_render_replay_aware_rendered_state_eighth_cycle_local_render_request_executed");
		assertContains(summary, "scheduleKind=local_render_scheduled;scheduleRequested=true;scheduled=true");
		assertContains(summary,
			"schedulerSummary=typed_response_recovery_post_completion_post_render_replay_aware_rendered_state_eighth_cycle_local_render:thread-surface-a");
		assertNotContains(summary, "post_completion_post_render_replay_aware_rendered_state_eighth_cycle_local_render_request_execution_rejected");
		assertNotContains(summary, "render_execution_rejected");
		assertNotContains(summary, "render_schedule_rejected");
		assertNotContains(summary, "render_intent_rejected");
		assertNotContains(summary, "input_rejected");
		assertNotContains(summary, "completion_rejected");
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
