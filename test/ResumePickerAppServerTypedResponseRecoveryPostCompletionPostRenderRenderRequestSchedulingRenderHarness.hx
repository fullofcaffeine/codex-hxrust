import codexhx.runtime.tui.resume.live.PostRenderRenderRequestGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderRequestSchedulingRenderHarness {
	static function main():Void {
		final report = PostRenderRenderRequestGate.run();

		assertEquals("local_render_scheduled", Std.string(report.scheduleKind), "schedule kind");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertEquals("footer keyboard move_up selected=0 selectedThread=thread-surface-a", report.finalFooter, "final footer");
		assertTrue(report.scheduleRequested, "schedule should be requested");
		assertTrue(report.scheduled, "render request should be scheduled");
		assertEquals("1", Std.string(report.scheduleSequence), "schedule sequence");
		assertEquals("1", Std.string(report.schedulerRequestCount), "scheduler request count");
		assertEquals("typed_response_recovery_post_completion_post_render_local_render:thread-surface-a", report.schedulerSummary, "scheduler reason");
		assertEquals("2", Std.string(report.replayCount), "replay count");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.sourceRenderCount), "source render count");
		assertTrue(report.localOnlyRenderIntent, "render intent should stay local-only");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertTrue(report.snapshotOrderPreserved, "snapshot order should be preserved");
		assertTrue(report.selectedMarkersPreserved, "selected markers should be preserved");
		assertTrue(report.footerSummariesPreserved, "footer summaries should be preserved");
		assertTrue(report.selectedMarkerMoved, "selected marker movement should carry forward");
		assertTrue(report.recoveredSelectionRestored, "recovered selection should stay restored");
		assertTrue(report.noLeftoverScheduledRenderRequest, "source scheduled render request should remain consumed");
		assertTrue(report.renderedSnapshotPreserved, "source rendered snapshot should be preserved");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "render scheduling should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(),
			"scheduleKind=local_render_scheduled;scheduleRequested=true;scheduled=true;scheduleSequence=1;schedulerRequestCount=1");
		assertContains(report.summary(), "schedulerSummary=typed_response_recovery_post_completion_post_render_local_render:thread-surface-a");
		assertContains(report.summary(), "kind=local_render_scheduled;sourceRenderIntentKind=local_render_requested");
		assertContains(report.summary(), "schedulerPendingCount=1;schedulerSkippedCount=0");
		assertContains(report.summary(), "finalSelectionPreserved=true;finalFooterPreserved=true;inputAdmitted=true;replayCount=2");
		assertContains(report.summary(), "snapshotOrderPreserved=true;selectedMarkersPreserved=true;footerSummariesPreserved=true");
		assertContains(report.summary(), "selectedMarkerMoved=true;recoveredSelectionRestored=true;noLeftoverScheduledRenderRequest=true");
		assertContains(report.summary(), "sourceSchedulerRequestCount=1;consumedScheduledRequestCount=1;sourceRenderCount=1");
		assertContains(report.summary(), "inputAdmitted=true;localOnlyRenderIntent=true");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true;reason=post_completion_post_render_local_render_request_scheduled");
		assertContains(report.summary(), "renderIntentKind=local_render_requested;renderRequested=true;localOnlyRenderIntent=true");
		assertContains(report.summary(), "reason=post_completion_post_render_input_local_render_intent_requested");
		assertNotContains(report.summary(), "post_completion_post_render_local_render_request_rejected");
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
