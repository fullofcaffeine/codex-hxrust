package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoffKind;

class ReplayStateCompletionHandoffGate {
	public static function run():ReplayStateCompletionHandoffReport {
		final replayReport = ReplayStateSnapshotReplayGate.run();
		final policy = new ReplayStateCompletionHandoffPolicy();
		final handoff = policy.handoff(replayReport);
		return new ReplayStateCompletionHandoffReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			completionReady: handoff.kind == RecoveryReplayCompletionHandoffKind.CompletedRecoveredSelection,
			sourceReadinessDecisionCount: replayReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: replayReport.sourceRenderStateCount,
			sourceFrameRequests: replayReport.sourceFrameRequests,
			sourceKeyboardRenderCount: replayReport.sourceKeyboardRenderCount,
			replayCount: handoff.replayCount,
			sourceReplayCount: replayReport.sourceReplayCount,
			sourceHandoffReplayCount: replayReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: replayReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: replayReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: replayReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: replayReport.sourceHandoffKeyboardRenderCount,
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
			sourcePostRenderRenderCount: replayReport.sourcePostRenderRenderCount,
			renderedSnapshotPreserved: replayReport.renderedSnapshotPreserved,
			sourceRenderedSnapshotPreserved: replayReport.sourceRenderedSnapshotPreserved,
			finalSelectionPreserved: replayReport.finalSelectionPreserved,
			finalFooterPreserved: replayReport.finalFooterPreserved,
			inputAdmitted: replayReport.inputAdmitted,
			localOnlyRenderIntent: replayReport.localOnlyRenderIntent,
			sourceInputAdmitted: replayReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: replayReport.sourceLocalOnlyRenderIntent,
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
