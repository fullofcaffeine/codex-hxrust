package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.CompletionInputIntentKind;

class ReplayAwareInputAdmissionGate {
	public static function run():ReplayAwareInputAdmissionReport {
		final completionReport = ReplayAwareCompletionHandoffGate.run();
		final policy = new ReplayAwareInputAdmissionPolicy();
		final admission = policy.admit(completionReport, CompletionInputIntentKind.ConfirmRecoveredSelection);
		return new ReplayAwareInputAdmissionReport({
			admissionKind: admission.kind,
			admissionSummary: admission.summary(),
			inputAdmitted: admission.kind == CompletionInputAdmissionKind.InputAdmitted,
			sourceReadinessDecisionCount: completionReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: completionReport.sourceRenderStateCount,
			sourceFrameRequests: completionReport.sourceFrameRequests,
			sourceKeyboardRenderCount: completionReport.sourceKeyboardRenderCount,
			replayCount: completionReport.replayCount,
			sourceReplayCount: completionReport.sourceReplayCount,
			finalThreadId: admission.finalThreadId,
			finalFooter: admission.finalFooter,
			finalSelectionPreserved: admission.finalSelectionPreserved,
			finalFooterPreserved: admission.finalFooterPreserved,
			completionReady: admission.completionReady,
			nextSliceReady: admission.nextSliceReady,
			snapshotOrderPreserved: completionReport.snapshotOrderPreserved,
			selectedMarkersPreserved: completionReport.selectedMarkersPreserved,
			footerSummariesPreserved: completionReport.footerSummariesPreserved,
			selectedMarkerMoved: completionReport.selectedMarkerMoved,
			recoveredSelectionRestored: completionReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: completionReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: completionReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: completionReport.consumedScheduledRequestCount,
			sourcePostRenderRenderCount: completionReport.sourcePostRenderRenderCount,
			renderedSnapshotPreserved: completionReport.renderedSnapshotPreserved,
			sourceRenderedSnapshotPreserved: completionReport.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: completionReport.inputAdmitted,
			sourceLocalOnlyRenderIntent: completionReport.localOnlyRenderIntent,
			stalePromptActionInactive: admission.stalePromptActionInactive,
			staleSideParentActionInactive: admission.staleSideParentActionInactive,
			staleActiveThreadActionInactive: admission.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: admission.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: admission.noPressureDropRejection,
			liveTransportSuppressed: admission.liveTransportSuppressed,
			liveTerminalSuppressed: admission.liveTerminalSuppressed,
			stateDbUntouched: admission.stateDbUntouched,
			noModelCall: admission.noModelCall,
			noFilesystemMutation: admission.noFilesystemMutation,
			finalSnapshot: completionReport.finalSnapshot,
			completionSummary: completionReport.summary(),
			admissionLogSummaries: policy.summaries()
		});
	}
}
