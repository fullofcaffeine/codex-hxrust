import codexhx.runtime.tui.resume.live.CompletionInputRenderIntentGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentRenderHarness {
	static function main():Void {
		final report = CompletionInputRenderIntentGate.run();

		assertEquals("local_render_requested", Std.string(report.renderIntentKind), "render intent kind");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertTrue(report.renderRequested, "render should be requested");
		assertTrue(report.localOnlyRenderIntent, "render intent should stay local-only");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.inputAdmitted, "source input should be admitted");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "render intent should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(),
			"renderIntentKind=local_render_requested;renderRequested=true;localOnlyRenderIntent=true;finalThread=thread-surface-a");
		assertContains(report.summary(), "kind=local_render_requested;sourceIntent=confirm_recovered_selection;renderRequested=true;renderSequence=1");
		assertContains(report.summary(), "finalSelectionPreserved=true;finalFooterPreserved=true;inputAdmitted=true;localOnlyRenderIntent=true");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true;reason=post_completion_input_local_render_intent_requested");
		assertContains(report.summary(), "admissionKind=input_admitted;inputAdmitted=true");
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
