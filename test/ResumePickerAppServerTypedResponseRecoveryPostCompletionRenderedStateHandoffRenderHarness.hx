import codexhx.validation.tui.resume.live.CompletionStateHandoffGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffRenderHarness {
	static function main():Void {
		final report = CompletionStateHandoffGate.run();

		assertEquals("rendered_idle_list_ready", Std.string(report.handoffKind), "handoff kind");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertTrue(report.postRenderIdleListReady, "post-render state should be idle/list ready");
		assertTrue(report.keyboardInputReady, "keyboard input should be ready");
		assertTrue(report.listNavigationReady, "list navigation should be ready");
		assertTrue(report.noLeftoverScheduledRenderRequest, "scheduled render request should be consumed");
		assertEquals("1", Std.string(report.sourceSchedulerRequestCount), "source scheduler request count");
		assertEquals("1", Std.string(report.consumedScheduledRequestCount), "consumed scheduled request count");
		assertEquals("1", Std.string(report.renderCount), "render count");
		assertTrue(report.renderedSnapshotPreserved, "rendered snapshot should be preserved");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertTrue(report.localOnlyRenderIntent, "render intent should stay local-only");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "handoff should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "handoffKind=rendered_idle_list_ready;postRenderIdleListReady=true;keyboardInputReady=true;listNavigationReady=true");
		assertContains(report.summary(), "noLeftoverScheduledRenderRequest=true;sourceSchedulerRequestCount=1;consumedScheduledRequestCount=1");
		assertContains(report.summary(), "renderCount=1;renderedSnapshotPreserved=true;finalThread=thread-surface-a");
		assertContains(report.summary(), "kind=rendered_idle_list_ready;sourceExecutionKind=local_render_executed");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true");
		assertContains(report.summary(), "reason=post_completion_rendered_state_handed_to_idle_list");
		assertContains(report.summary(), "executionKind=local_render_executed;executionRequested=true;rendered=true");
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
