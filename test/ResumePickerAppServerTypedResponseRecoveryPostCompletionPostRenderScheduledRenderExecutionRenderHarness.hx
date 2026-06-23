import codexhx.runtime.tui.resume.live.PostRenderScheduledRenderGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderScheduledRenderExecutionRenderHarness {
	static function main():Void {
		final report = PostRenderScheduledRenderGate.run();

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
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertEquals("2", Std.string(report.replayCount), "replay count");
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
		assertContains(report.summary(),
			"executionKind=local_render_executed;executionRequested=true;rendered=true;executionSequence=1;sourceSchedulerRequestCount=1");
		assertContains(report.summary(), "consumedScheduledRequestCount=1;renderCount=1;renderOutcomeKind=rendered");
		assertContains(report.summary(), "renderedSnapshotMatchesSchedule=true;localOnlyRenderIntent=true;finalThread=thread-surface-a");
		assertContains(report.summary(), "finalFooter=footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "inputAdmitted=true;replayCount=2;snapshotOrderPreserved=true;selectedMarkersPreserved=true");
		assertContains(report.summary(), "footerSummariesPreserved=true;selectedMarkerMoved=true;recoveredSelectionRestored=true");
		assertContains(report.summary(), "noLeftoverScheduledRenderRequest=true;sourcePreExecutionSchedulerRequestCount=1");
		assertContains(report.summary(), "sourcePreExecutionConsumedRequestCount=1;sourcePreExecutionRenderCount=1");
		assertContains(report.summary(), "kind=local_render_executed;sourceScheduleKind=local_render_scheduled");
		assertContains(report.summary(), "renderOutcomePendingCount=1;renderedSnapshotMatchesSchedule=true");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true;renderedSnapshot=");
		assertContains(report.summary(), "reason=post_completion_post_render_local_render_request_executed");
		assertContains(report.summary(), "scheduleKind=local_render_scheduled;scheduleRequested=true;scheduled=true");
		assertContains(report.summary(), "schedulerSummary=typed_response_recovery_post_completion_post_render_local_render:thread-surface-a");
		assertNotContains(report.summary(), "post_completion_post_render_local_render_request_execution_rejected");
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
