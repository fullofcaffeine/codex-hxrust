import codexhx.runtime.tui.resume.live.CompletionInputAdmissionGate;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionRenderHarness {
	static function main():Void {
		final report = CompletionInputAdmissionGate.run();

		assertEquals("input_admitted", Std.string(report.admissionKind), "admission kind");
		assertEquals("thread-surface-a", report.finalThreadId, "final thread");
		assertTrue(report.inputAdmitted, "input should be admitted");
		assertTrue(report.finalSelectionPreserved, "final selection should be preserved");
		assertTrue(report.finalFooterPreserved, "final footer should be preserved");
		assertTrue(report.completionReady, "completion should be ready");
		assertTrue(report.nextSliceReady, "next slice should be ready");
		assertTrue(report.stalePromptActionInactive, "stale prompt action should stay inactive");
		assertTrue(report.staleSideParentActionInactive, "stale side-parent action should stay inactive");
		assertTrue(report.staleActiveThreadActionInactive, "stale active-thread action should stay inactive");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.noPressureDropRejection, "post-completion input should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.liveTerminalSuppressed, "live terminal should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertTrue(report.noModelCall, "model call should not run");
		assertTrue(report.noFilesystemMutation, "filesystem should not mutate");
		assertContains(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		assertContains(report.finalSnapshot, "footer keyboard move_up selected=0 selectedThread=thread-surface-a");
		assertContains(report.summary(), "admissionKind=input_admitted;inputAdmitted=true;finalThread=thread-surface-a");
		assertContains(report.summary(), "kind=input_admitted;intent=confirm_recovered_selection;admitted=true;sequence=1;finalThread=thread-surface-a");
		assertContains(report.summary(), "completionReady=true;nextSliceReady=true;finalSelectionPreserved=true;finalFooterPreserved=true");
		assertContains(report.summary(), "noModelCall=true;noFilesystemMutation=true;reason=post_completion_input_admitted_after_recovery");
		assertContains(report.summary(), "handoffKind=completed_recovered_selection;completionReady=true");
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
