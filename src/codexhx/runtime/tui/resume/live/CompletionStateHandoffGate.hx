package codexhx.runtime.tui.resume.live;

class CompletionStateHandoffGate {
	public static function run():CompletionStateHandoffReport {
		final executionReport = CompletionScheduledRenderGate.run();
		final policy = new CompletionStateHandoffPolicy();
		final handoff = policy.handoff(executionReport);
		return new CompletionStateHandoffReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			postRenderIdleListReady: handoff.postRenderIdleListReady,
			keyboardInputReady: handoff.keyboardInputReady,
			listNavigationReady: handoff.listNavigationReady,
			noLeftoverScheduledRenderRequest: handoff.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: handoff.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: handoff.consumedScheduledRequestCount,
			renderCount: handoff.renderCount,
			renderedSnapshotPreserved: handoff.renderedSnapshotPreserved,
			finalThreadId: handoff.finalThreadId,
			finalSelectionPreserved: handoff.finalSelectionPreserved,
			finalFooterPreserved: handoff.finalFooterPreserved,
			inputAdmitted: handoff.inputAdmitted,
			localOnlyRenderIntent: handoff.localOnlyRenderIntent,
			stalePromptActionInactive: handoff.stalePromptActionInactive,
			staleSideParentActionInactive: handoff.staleSideParentActionInactive,
			staleActiveThreadActionInactive: handoff.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: handoff.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: handoff.noPressureDropRejection,
			liveTransportSuppressed: handoff.liveTransportSuppressed,
			liveTerminalSuppressed: handoff.liveTerminalSuppressed,
			stateDbUntouched: handoff.stateDbUntouched,
			noModelCall: handoff.noModelCall,
			noFilesystemMutation: handoff.noFilesystemMutation,
			finalSnapshot: handoff.finalSnapshot,
			executionSummary: executionReport.summary(),
			handoffLogSummaries: policy.summaries()
		});
	}
}
