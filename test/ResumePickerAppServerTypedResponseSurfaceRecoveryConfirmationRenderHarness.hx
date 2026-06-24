import codexhx.runtime.tui.resume.host.SurfaceRecoveryConfirmationKind;
import codexhx.validation.tui.resume.live.SurfaceRecoveryConfirmationGate;

class ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderHarness {
	static function main():Void {
		final report = SurfaceRecoveryConfirmationGate.run();

		assertTrue(report.recoveryConfirmed, "recovery confirmation should succeed");
		assertEquals("recovery_confirmed", Std.string(report.confirmationKind), "confirmation kind");
		assertEquals(Std.string(SurfaceRecoveryConfirmationKind.RecoveryConfirmed), Std.string(report.confirmationKind), "confirmation enum");
		assertEquals("15", Std.string(report.surfaceUpdateCount), "surface updates");
		assertEquals("16", Std.string(report.recoveryFrameIndex), "recovery frame index");
		assertEquals("17", Std.string(report.frameRequests), "frame requests");
		assertEquals("17", Std.string(report.renderCount), "render count");
		assertEquals("1", Std.string(report.pageRequests), "page requests");
		assertEquals("0", Std.string(report.readRequests), "read requests");
		assertEquals("thread-surface-a", report.recoveredThreadId, "recovered thread");
		assertEquals("typed surface recovered", report.recoveredFooterLabel, "recovered footer");
		assertEquals("typed_response_replay_surface_recovery_page_decoded", report.recoveredLoaderStatus, "recovered loader");
		assertTrue(report.pendingInteractiveSurfaceCleared, "pending prompt surface should be cleared");
		assertTrue(report.sideParentSurfaceCleared, "side-parent surface should be cleared");
		assertTrue(report.activeThreadSurfaceReplaced, "active-thread surface should be replaced");
		assertTrue(report.staleSurfaceLoaderAbsent, "stale surface loaders should be absent");
		assertTrue(report.ignoredNoSurfaceRecordsAbsent, "ignored no-surface records should remain absent");
		assertTrue(report.recoveryPageDecoded, "recovery page should be decoded");
		assertTrue(report.recoverySelectionPreserved, "recovery selection should be preserved");
		assertTrue(report.noPressureDropRejection, "confirmation should not report pressure rejection");
		assertTrue(report.liveTransportSuppressed, "live transport should stay suppressed");
		assertTrue(report.stateDbUntouched, "state DB should stay untouched");
		assertContains(report.finalSnapshot, "loader status=typed_response_replay_surface_recovery_page_decoded");
		assertContains(report.finalSnapshot, "footer typed surface recovered selected=0 selectedThread=thread-surface-a");
		assertNotContains(report.finalSnapshot, "typed_response_replay_surface_pending_interactive_prompt");
		assertNotContains(report.finalSnapshot, "typed_response_replay_surface_side_parent_status");
		assertNotContains(report.finalSnapshot, "typed_response_replay_surface_active_thread_status");
		assertNotContains(report.finalSnapshot, "typed-surface-dynamic-6");
		assertContains(report.summary(), "recoveryConfirmed=true");
		assertContains(report.summary(), "reason=recovery_page_replaced_transient_response_surfaces");
		assertContains(report.summary(), "ignoredNoSurfaceAbsent=true");
		assertContains(report.summary(), "surfaceUpdates=[kind=pending_interactive_prompt;class=exec_approval");
		assertContains(report.summary(), "states=[surface-1:");
		assertContains(report.summary(), "##page:thread=thread-surface-a");

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
