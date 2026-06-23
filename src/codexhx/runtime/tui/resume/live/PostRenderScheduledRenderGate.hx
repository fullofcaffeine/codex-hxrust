package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;

class PostRenderScheduledRenderGate {
	public static function run():PostRenderScheduledRenderReport {
		final schedulingReport = PostRenderRenderRequestGate.run();
		final renderer = new DeterministicTerminalRenderer();
		final executor = new PostRenderScheduledRenderExecutor();
		final execution = executor.execute(schedulingReport, renderer);
		return new PostRenderScheduledRenderReport({
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
			finalThreadId: execution.finalThreadId,
			finalFooter: execution.finalFooter,
			finalSelectionPreserved: execution.finalSelectionPreserved,
			finalFooterPreserved: execution.finalFooterPreserved,
			inputAdmitted: execution.inputAdmitted,
			replayCount: schedulingReport.replayCount,
			snapshotOrderPreserved: schedulingReport.snapshotOrderPreserved,
			selectedMarkersPreserved: schedulingReport.selectedMarkersPreserved,
			footerSummariesPreserved: schedulingReport.footerSummariesPreserved,
			selectedMarkerMoved: schedulingReport.selectedMarkerMoved,
			recoveredSelectionRestored: schedulingReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: schedulingReport.noLeftoverScheduledRenderRequest,
			sourcePreExecutionSchedulerRequestCount: schedulingReport.sourceSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: schedulingReport.consumedScheduledRequestCount,
			sourcePreExecutionRenderCount: schedulingReport.sourceRenderCount,
			sourceRenderedSnapshotPreserved: schedulingReport.renderedSnapshotPreserved,
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
