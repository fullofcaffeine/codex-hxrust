package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;

class ReplayStateScheduledRenderGate {
	public static function run():ReplayStateScheduledRenderReport {
		final schedulingReport = ReplayStateRenderRequestGate.run();
		final renderer = new DeterministicTerminalRenderer();
		final executor = new ReplayStateScheduledRenderExecutor();
		final execution = executor.execute(schedulingReport, renderer);
		return new ReplayStateScheduledRenderReport({
			executionKind: execution.kind,
			executionSummary: execution.summary(),
			executionRequested: execution.executionRequested,
			rendered: execution.rendered,
			executionSequence: execution.executionSequence,
			sourceSchedulerRequestCount: execution.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: execution.consumedScheduledRequestCount,
			renderCount: execution.renderCount,
			renderOutcomeKind: execution.renderOutcomeKind,
			renderedSnapshotMatchesSchedule: execution.renderedSnapshotMatchesSchedule,
			localOnlyRenderIntent: execution.localOnlyRenderIntent,
			sourceReadinessDecisionCount: schedulingReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: schedulingReport.sourceRenderStateCount,
			sourceFrameRequests: schedulingReport.sourceFrameRequests,
			sourceKeyboardRenderCount: schedulingReport.sourceKeyboardRenderCount,
			replayCount: schedulingReport.replayCount,
			sourceReplayCount: schedulingReport.sourceReplayCount,
			sourceHandoffReplayCount: schedulingReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: schedulingReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: schedulingReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: schedulingReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: schedulingReport.sourceHandoffKeyboardRenderCount,
			finalThreadId: execution.finalThreadId,
			finalFooter: execution.finalFooter,
			finalSelectionPreserved: execution.finalSelectionPreserved,
			finalFooterPreserved: execution.finalFooterPreserved,
			inputAdmitted: execution.inputAdmitted,
			completionReady: schedulingReport.completionReady,
			nextSliceReady: schedulingReport.nextSliceReady,
			snapshotOrderPreserved: schedulingReport.snapshotOrderPreserved,
			selectedMarkersPreserved: schedulingReport.selectedMarkersPreserved,
			footerSummariesPreserved: schedulingReport.footerSummariesPreserved,
			selectedMarkerMoved: schedulingReport.selectedMarkerMoved,
			recoveredSelectionRestored: schedulingReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: schedulingReport.noLeftoverScheduledRenderRequest,
			sourcePreExecutionSchedulerRequestCount: schedulingReport.sourceSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: schedulingReport.consumedScheduledRequestCount,
			sourcePreExecutionRenderCount: schedulingReport.sourcePostRenderRenderCount,
			sourceRenderedSnapshotPreserved: schedulingReport.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: schedulingReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: schedulingReport.sourceLocalOnlyRenderIntent,
			sourceHandoffInputAdmitted: schedulingReport.sourceHandoffInputAdmitted,
			sourceHandoffLocalOnlyRenderIntent: schedulingReport.sourceHandoffLocalOnlyRenderIntent,
			stalePromptActionInactive: execution.stalePromptActionInactive,
			staleSideParentActionInactive: execution.staleSideParentActionInactive,
			staleActiveThreadActionInactive: execution.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: execution.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: execution.noPressureDropRejection,
			liveTransportSuppressed: execution.liveTransportSuppressed,
			liveTerminalSuppressed: execution.liveTerminalSuppressed,
			stateDbUntouched: execution.stateDbUntouched,
			noModelCall: execution.noModelCall,
			noFilesystemMutation: execution.noFilesystemMutation,
			renderedSnapshot: execution.renderedSnapshot,
			schedulingSummary: schedulingReport.summary(),
			executionLogSummaries: executor.summaries()
		});
	}
}
