package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputRenderIntentKind;

class ReplayStateInputRenderIntentGate {
	public static function run():ReplayStateInputRenderIntentReport {
		final admissionReport = ReplayStateInputAdmissionGate.run();
		final planner = new ReplayStateInputRenderIntentPlanner();
		final intent = planner.plan(admissionReport);
		return new ReplayStateInputRenderIntentReport({
			renderIntentKind: intent.kind,
			renderIntentSummary: intent.summary(),
			renderRequested: intent.kind == CompletionInputRenderIntentKind.LocalRenderRequested,
			localOnlyRenderIntent: intent.localOnlyRenderIntent,
			sourceReadinessDecisionCount: admissionReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: admissionReport.sourceRenderStateCount,
			sourceFrameRequests: admissionReport.sourceFrameRequests,
			sourceKeyboardRenderCount: admissionReport.sourceKeyboardRenderCount,
			replayCount: admissionReport.replayCount,
			sourceReplayCount: admissionReport.sourceReplayCount,
			sourceHandoffReplayCount: admissionReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: admissionReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: admissionReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: admissionReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: admissionReport.sourceHandoffKeyboardRenderCount,
			finalThreadId: intent.finalThreadId,
			finalFooter: intent.finalFooter,
			finalSelectionPreserved: intent.finalSelectionPreserved,
			finalFooterPreserved: intent.finalFooterPreserved,
			inputAdmitted: intent.inputAdmitted,
			completionReady: admissionReport.completionReady,
			nextSliceReady: admissionReport.nextSliceReady,
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
			sourceHandoffInputAdmitted: admissionReport.sourceHandoffInputAdmitted,
			sourceHandoffLocalOnlyRenderIntent: admissionReport.sourceHandoffLocalOnlyRenderIntent,
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
