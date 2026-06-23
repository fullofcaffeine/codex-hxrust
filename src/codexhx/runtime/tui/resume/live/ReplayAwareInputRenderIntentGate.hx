package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputRenderIntentKind;

class ReplayAwareInputRenderIntentGate {
	public static function run():ReplayAwareInputRenderIntentReport {
		final admissionReport = ReplayAwareInputAdmissionGate.run();
		final planner = new ReplayAwareInputRenderIntentPlanner();
		final intent = planner.plan(admissionReport);
		return new ReplayAwareInputRenderIntentReport({
			renderIntentKind: intent.kind,
			renderIntentSummary: intent.summary(),
			renderRequested: intent.kind == CompletionInputRenderIntentKind.LocalRenderRequested,
			localOnlyRenderIntent: intent.localOnlyRenderIntent,
			sourceReadinessDecisionCount: admissionReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: admissionReport.sourceRenderStateCount,
			sourceFrameRequests: admissionReport.sourceFrameRequests,
			sourceKeyboardRenderCount: admissionReport.sourceKeyboardRenderCount,
			finalThreadId: intent.finalThreadId,
			finalFooter: intent.finalFooter,
			finalSelectionPreserved: intent.finalSelectionPreserved,
			finalFooterPreserved: intent.finalFooterPreserved,
			inputAdmitted: intent.inputAdmitted,
			replayCount: admissionReport.replayCount,
			sourceReplayCount: admissionReport.sourceReplayCount,
			snapshotOrderPreserved: admissionReport.snapshotOrderPreserved,
			selectedMarkersPreserved: admissionReport.selectedMarkersPreserved,
			footerSummariesPreserved: admissionReport.footerSummariesPreserved,
			selectedMarkerMoved: admissionReport.selectedMarkerMoved,
			recoveredSelectionRestored: admissionReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: admissionReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: admissionReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: admissionReport.consumedScheduledRequestCount,
			sourcePostRenderRenderCount: admissionReport.sourcePostRenderRenderCount,
			renderedSnapshotPreserved: admissionReport.renderedSnapshotPreserved,
			sourceRenderedSnapshotPreserved: admissionReport.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: admissionReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: admissionReport.sourceLocalOnlyRenderIntent,
			stalePromptActionInactive: intent.stalePromptActionInactive,
			staleSideParentActionInactive: intent.staleSideParentActionInactive,
			staleActiveThreadActionInactive: intent.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: intent.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: intent.noPressureDropRejection,
			liveTransportSuppressed: intent.liveTransportSuppressed,
			liveTerminalSuppressed: intent.liveTerminalSuppressed,
			stateDbUntouched: intent.stateDbUntouched,
			noModelCall: intent.noModelCall,
			noFilesystemMutation: intent.noFilesystemMutation,
			finalSnapshot: admissionReport.finalSnapshot,
			admissionSummary: admissionReport.summary(),
			renderIntentLogSummaries: planner.summaries()
		});
	}
}
