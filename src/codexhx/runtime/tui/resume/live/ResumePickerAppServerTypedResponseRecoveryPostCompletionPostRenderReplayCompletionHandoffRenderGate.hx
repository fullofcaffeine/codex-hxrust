package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffRenderGateReport {
		final replayReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardRenderSnapshotReplayRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffPolicy();
		final handoff = policy.handoff(replayReport);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffRenderGateReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			completionReady: handoff.kind == ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind.CompletedRecoveredSelection,
			replayCount: handoff.replayCount,
			finalThreadId: handoff.finalThreadId,
			finalFooter: handoff.finalFooter,
			finalFooterStable: handoff.finalFooterStable,
			finalSelectionRestored: handoff.finalSelectionRestored,
			snapshotOrderPreserved: handoff.snapshotOrderPreserved,
			selectedMarkersPreserved: handoff.selectedMarkersPreserved,
			footerSummariesPreserved: handoff.footerSummariesPreserved,
			selectedMarkerMoved: replayReport.selectedMarkerMoved,
			recoveredSelectionRestored: replayReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: replayReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: replayReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: replayReport.consumedScheduledRequestCount,
			sourceRenderCount: replayReport.sourceRenderCount,
			renderedSnapshotPreserved: replayReport.renderedSnapshotPreserved,
			finalSelectionPreserved: replayReport.finalSelectionPreserved,
			finalFooterPreserved: replayReport.finalFooterPreserved,
			stalePromptActionInactive: handoff.stalePromptActionInactive,
			staleSideParentActionInactive: handoff.staleSideParentActionInactive,
			staleActiveThreadActionInactive: handoff.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: handoff.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: handoff.noPressureDropRejection,
			liveTransportSuppressed: handoff.liveTransportSuppressed,
			liveTerminalSuppressed: handoff.liveTerminalSuppressed,
			stateDbUntouched: handoff.stateDbUntouched,
			noModelCall: replayReport.noModelCall,
			noFilesystemMutation: replayReport.noFilesystemMutation,
			nextSliceReady: handoff.nextSliceReady,
			finalSnapshot: replayReport.finalSnapshot,
			handoffLogSummaries: policy.summaries(),
			replaySummary: replayReport.summary()
		});
	}
}
